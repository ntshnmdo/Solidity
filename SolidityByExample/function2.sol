/*
function overloading: solidity allows multiple functions with the same name but different parameters
*/

// SPDX-License-Identidier: MIT
pragma solidity ^0.8.26;

contract OverloadExample {

    function sum(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

    function sum(uint a, uint b, uint c) public pure returns(uint) {
        return a + b + c;
    }
}