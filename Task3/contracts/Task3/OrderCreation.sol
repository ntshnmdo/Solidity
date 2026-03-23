// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract OrderManager {

    // Struct: Custom data type
    struct Order {
        uint256 id;
        address buyer;
        uint256 amount;
    }

    // array, stores all orders
    Order[] public orders;

    // Counter for unique IDs
    uint256 public nextId;

    event OrderCreated(uint256 id, address buyer, uint256 amount);

    function createOrder(uint256 amount) public {

        // Optional check
        require(amount > 0, "Amount must be > 0");

        // Create order: Temporary object in memory
        Order memory newOrder = Order({
            id: nextId,
            buyer: msg.sender,
            amount: amount
        });

        // pushing to array
        orders.push(newOrder);

        emit OrderCreated(nextId, msg.sender, amount);

        // Increment ID: Next order gets new ID
        nextId++;
    }
}