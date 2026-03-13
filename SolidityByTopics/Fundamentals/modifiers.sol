/*
Modifiers are reusable conditions that run before or after a function.

they are mainly used for access control
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Ownable {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function withdraw() public onlyOwner {
        // only owner can execute
    }


}