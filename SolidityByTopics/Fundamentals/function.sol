/*
functions define the logic of the contract

they can:
- read data
- modify data
- transfer ETH
- interact with other contracts
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Counter {
    uint public count;
    function increment() public {
        count++;
    }

    function getCount() public view returns (uint) {
        return count;
    }
}