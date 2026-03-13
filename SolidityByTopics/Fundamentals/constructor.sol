// constructor in solidity 
// constructor is a special function that runs only once, when the smart contract is deplyoed to the blockchain
// after deployment, the constructor cannot be called again

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Example {

    address public owner;

    constructor() {
        owner = msg.sender;
    }
}

/*
when the contract is deployed:
- the constructor() runs auto
- msg.sender is the address that deployed the contract
- that address is stored in the variable owner.
so the deployer becomes the owner of the contract.

used for initialization - set owner, initial values, configuration
*/