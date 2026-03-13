// msg context

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MsgExample {

    address public lastCaller;
    uint public lastValue;

    function deposit() public payable {
        lastCaller = msg.sender;
        lastValue = msg.value;
    }
}

// msg.sender -> caller's address
// msg.value -> 1 ether

/*
block provides information about the current block

block.timestamp -> current block time(seconds)

*/