// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

error NotOwner();

contract ErrorExample {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw(uint amount) public {

        require(amount > 0, "Invalid amount");

        if (msg.sender != owner) {
            revert NotOwner();
        }

        assert(owner != address(0));
    }
}