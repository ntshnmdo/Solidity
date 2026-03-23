// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ConfigManager {

// owner setup
// stores who control the contract
    address public owner;
    uint256 public configValue;

    // using custom error: gas-efficient way to handle unauthorized access
    error NotOwner();

    // set owner when contract is deployed
    // runs once at deployment
    // whoever deploys = owner
    constructor() {
        owner = msg.sender;
    }

    // modifier to restrict access
    // checks if caller is owner
     // if not, revert transaction

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;  // else continue execution
    }

    // function to update config: only owner can call this
    function updateConfig(uint256 newValue) public onlyOwner {
        configValue = newValue;
    }
}