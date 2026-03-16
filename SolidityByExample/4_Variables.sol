/*
Variables (Solidity Code Example)

There are 3 types of variables in solidity

- local
declared inside a function
not stored in blockchain

- state 
declared outside a function
stored on the blockchain

- global (provides info about the blockchain)
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Variables {
    // state variable are stored on the blockchain
    string public text = "Hello";
    uint public num = 123;

    function doSomething() public {
        // local variables are not saved in blockchain 
        uint256 i = 456;

        // global variables
        uint256 timestamp = block.timestamp; // current block timestamp
        address sender = msg.sender; // address of the caller
    }
}