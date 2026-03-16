// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssemblyPractice {
    function addNumbers (uint a, uint b) public pure returns (uint result) {
        assembly {
            result := add (a,b)
        }
    }

    function storeAndRead() public pure returns (uint result) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 42)
            result := mload(ptr)
        }
    }
}