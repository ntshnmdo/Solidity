// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./AccessManager.sol";
import "./IArbitrator.sol";

contract EscrowMarketplace is AccessManager {

    // STATE VARIABLES
    uint256 public orderCounter;
    uint256 public feeBps = 100; // 1% default

    address public treasury;
    IArbitrator public arbitrator;

    // Reentrancy lock
    bool private locked;

    // ENUMS
    enum OrderState {
        Created,
        Funded,
        Shipped,
        Completed,
        Disputed,
        Refunded,
        Cancelled
    }

    // STRUCT
    struct Order {
        uint256 id;
        address buyer;
        address seller;
        uint256 amount;
        uint256 createdAt;
        bytes32 detailsHash;
        OrderState state;
    }

    // STORAGE
    mapping(uint256 => Order) public orders;

    // EVENTS
    event OrderCreated(uint256 id, address buyer, address seller, bytes32 detailsHash);
    event OrderFunded(uint256 id, uint256 amount);
    event OrderShipped(uint256 id);
    event OrderCompleted(uint256 id, uint256 payout, uint256 fee);
    event DisputeOpened(uint256 id, address openedBy);
    event DisputeResolved(uint256 id, bool releasedToSeller);
    event Refunded(uint256 id, uint256 amount);
    event Cancelled(uint256 id);
    event FeeUpdated(uint256 oldBps, uint256 newBps);

    // MODIFIER
    modifier nonReentrant() {
        require(!locked, "REENTRANCY");
        locked = true;
        _;
        locked = false;
    }

    // CONSTRUCTOR
    constructor(address _treasury, address _arbitrator) {
        treasury = _treasury;
        arbitrator = IArbitrator(_arbitrator);
    }

    // CREATE ORDER
    function createOrder(address seller, bytes32 detailsHash) external {
        require(seller != address(0), "Invalid seller");

        orderCounter++;

        orders[orderCounter] = Order({
            id: orderCounter,
            buyer: msg.sender,
            seller: seller,
            amount: 0,
            createdAt: block.timestamp,
            detailsHash: detailsHash,
            state: OrderState.Created
        });

        emit OrderCreated(orderCounter, msg.sender, seller, detailsHash);
    }

    // FUND ORDER (ESCROW)
    function fundOrder(uint256 orderId) external payable {
        Order storage order = orders[orderId];

        require(msg.sender == order.buyer, "Not buyer");
        require(order.state == OrderState.Created, "Invalid state");
        require(msg.value > 0, "No ETH");

        order.amount = msg.value;
        order.state = OrderState.Funded;

        emit OrderFunded(orderId, msg.value);
    }

    // SELLER MARKS SHIPPED
    function markShipped(uint256 orderId) external {
        Order storage order = orders[orderId];

        require(msg.sender == order.seller, "Not seller");
        require(order.state == OrderState.Funded, "Invalid state");

        order.state = OrderState.Shipped;

        emit OrderShipped(orderId);
    }

    // BUYER CONFIRMS DELIVERY
    function confirmReceived(uint256 orderId) external nonReentrant {
        Order storage order = orders[orderId];

        require(msg.sender == order.buyer, "Not buyer");
        require(order.state == OrderState.Shipped, "Invalid state");

        uint256 fee = (order.amount * feeBps) / 10_000;
        uint256 payout = order.amount - fee;

        order.state = OrderState.Completed;

        // Pay seller
        (bool ok1, ) = order.seller.call{value: payout}("");
        require(ok1, "Seller payment failed");

        // Send fee to treasury
        (bool ok2, ) = treasury.call{value: fee}("");
        require(ok2, "Fee transfer failed");

        emit OrderCompleted(orderId, payout, fee);
    }

    // OPEN DISPUTE
    function openDispute(uint256 orderId) external {
        Order storage order = orders[orderId];

        require(msg.sender == order.buyer, "Not buyer");
        require(
            order.state == OrderState.Funded || order.state == OrderState.Shipped,
            "Invalid state"
        );

        order.state = OrderState.Disputed;

        // Notify arbitrator
        try arbitrator.notifyDispute(orderId) {} catch {}

        emit DisputeOpened(orderId, msg.sender);
    }

    // RESOLVE DISPUTE
    function resolveDispute(uint256 orderId, bool releaseToSeller)
        external
        onlyRole(MEDIATOR_ROLE)
        nonReentrant
    {
        Order storage order = orders[orderId];

        require(order.state == OrderState.Disputed, "Invalid state");

        if (releaseToSeller) {
            uint256 fee = (order.amount * feeBps) / 10_000;
            uint256 payout = order.amount - fee;

            order.state = OrderState.Completed;

            (bool ok1, ) = order.seller.call{value: payout}("");
            require(ok1, "Seller payment failed");

            (bool ok2, ) = treasury.call{value: fee}("");
            require(ok2, "Fee transfer failed");
        } else {
            order.state = OrderState.Refunded;

            (bool ok, ) = order.buyer.call{value: order.amount}("");
            require(ok, "Refund failed");

            emit Refunded(orderId, order.amount);
        }

        emit DisputeResolved(orderId, releaseToSeller);
    }

    // CANCEL UNFUNDED ORDER
    function cancelUnfunded(uint256 orderId) external {
        Order storage order = orders[orderId];

        require(msg.sender == order.buyer, "Not buyer");
        require(order.state == OrderState.Created, "Invalid state");

        order.state = OrderState.Cancelled;

        emit Cancelled(orderId);
    }

    // UPDATE FEE (ADMIN)
    function updateFee(uint256 newBps) external onlyRole(ADMIN_ROLE) {
        require(newBps <= 500, "Max 5%");

        uint256 old = feeBps;
        feeBps = newBps;

        emit FeeUpdated(old, newBps);
    }
}