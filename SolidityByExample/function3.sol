// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FunctionExample {

    uint public value;

    function setValue(uint _v) public {
        value = _v;
    }

    function getValue() public view returns(uint) {
        return value;
    }

    function add(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

    function add(uint a, uint b, uint c) public pure returns(uint) {
        return a + b + c;
    }
}
