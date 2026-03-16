// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MutabilityExample {

    uint public value = 10;

    function readValue() public view returns(uint) {
        return value;
    }

    function calculate(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

    function deposit() public payable {}

    function setValue(uint _v) public {
        value = _v;
    }
}