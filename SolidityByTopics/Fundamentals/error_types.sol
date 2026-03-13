// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract RequireExample {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == owner, "Not owner");
    }
}