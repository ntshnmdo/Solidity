// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ModifierDemo {
    address public owner;
    bool private locked;

    event Log(string message);

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        emit Log("checking owner");
        require(msg.sender == owner, "Not owner");
        _;
        emit Log("Owner check passed");
    }
    
    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }
    
    function test() public onlyOwner nonReentrant {
        emit Log("Inside function");
    }
}
