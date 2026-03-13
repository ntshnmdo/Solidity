/*
An interface defines only the function signatures of another contract.
it tells solidity how to interact with another contract, but does not implement the logic.

rules of interfaces
- no function body
- no state variables
- all functions are external
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IERC20 {
    function transfer(address to, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

// this interface allows contracts to interact with ERC20 tokens

// if you want to call a token contract

// IERC20 token = IERC20(tokenAddress);
// token.transfer(msg.sender, 100); 

