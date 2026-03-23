// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DepositTracker {

    mapping(address => uint256) public balances;

    event Deposited(address user, uint256 amount);

    // Custom error
    error ZeroEthNotAllowed();

    function deposit() public payable {
        // Gas-efficient check
        if (msg.value == 0) {
            revert ZeroEthNotAllowed();
        }

        balances[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }
}