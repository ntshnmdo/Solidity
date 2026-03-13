/*
reference types: stores a reference (pointer) to data, not the value itself.
this means multiple variables can refer to the same data location.

- arrays
- structs
- mappings
- data locations ( storage, calldata, memory)
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ArrayExample {
    uint[] public nums;

    function addNumber(uint _num) public {
        nums.push(_num);
    }

    function getLength() public view returns(uint) {
        return nums.length;
    }
}