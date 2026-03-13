/*
a contract is the main unit of code in solidity.
it is similar to a class in oop and contains state variables, functions, modifiers, events etc
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Counter {
    uint public count;
    function increment() public {
        count += 1;
    }
}

/*
key points:
- contracts store state (data on blockchain)
- contracts define functions to modify or read the state.
- contracts can interact with other contracts
*/