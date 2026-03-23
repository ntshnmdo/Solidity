// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DepositTracker {

    // Mapping to store the balances for each address/ users
    mapping(address => uint256) public balances;

    // event to log deposits
    event Deposited(address user, uint256 amount);

    // deposit function
    function deposit() public payable {

        // prevent zero ETH deposits
        require(msg.value > 0, "Must Send ETH");

        // update user balance
        balances[msg.sender] += msg.value;

        // emit event 
        emit Deposited(msg.sender, msg.value);

    }
}