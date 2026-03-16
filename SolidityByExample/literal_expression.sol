// SPDX-License-identifier: MIT
pragma solidity ^0.8.26;

contract Example {

    uint public price = 1 ether;
    uint public deadline = block.timestamp + 1 days;

    function calculate(uint a, uint b) public pure returns(uint) {
        return a + b * 2;
    }
}