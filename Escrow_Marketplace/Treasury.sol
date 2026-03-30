// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./AccessManager.sol";

contract Treasury is AccessManager {

    // Events
    event FeeReceived(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    // Receive ETH: triggers when 1) ETH sent directly 2) from ESCROW Marketplace
    receive() external payable {
        emit FeeReceived(msg.sender, msg.value);
    }

    // Fallback function: covers 1) unknown function calls 2) Extra safety
    fallback() external payable {
        emit FeeReceived(msg.sender, msg.value);
    }

    bool private locked;

    modifier nonReentrant() {
        require(!locked, "REENTRANCY");
        locked = true;
        _;
        locked = false;
    }

    // Withdraw funds (Admin only)
    function withdraw(address payable to, uint256 amount)
        external
        onlyRole(ADMIN_ROLE)
    {
        // balance check: Improves security
        require(address(this).balance >= amount, "INSUFFICIENT_BALANCE");

        (bool ok, ) = to.call{value: amount}("");
        require(ok, "ETH_TRANSFER_FAILED");

        emit Withdrawn(to, amount);
    }
}