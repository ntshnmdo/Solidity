// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract VisibilityExample {

    function publicFunc() public {}

    function privateFunc() private {}

    function internalFunc() internal {}

    function externalFunc() external {}

}

/*
Function selectors

Every function in solidity has a 4-byte identifier called the function selector.

derived from:
keccak256("functionName(parameterTypes)")

example function:
function transfer(address, uint256)

selector is the first 4 bytes of the hash.

bytes4 selector = bytes4(keccak256("transfer(address, uint256)"));

selectors are important for:
- low-level calls
- ABI encoding
- smart contract interaction
*/