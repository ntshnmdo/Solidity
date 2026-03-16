// immutables variables are like constants. values of immutable variables can be set inside the constructor but cannot be modified afterwards.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Immutable {
    // coding convention to upercase constant variables
    address public immutable MY_ADDRESS;
    uint256 public immutable MY_UINT;

    constructor (uint256 _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}