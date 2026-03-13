// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ContextExample {

    address public sender;
    uint public value;
    uint public blockNumber;

    function execute() public payable {
        sender = msg.sender;
        value = msg.value;
        blockNumber = block.number;
    }
}