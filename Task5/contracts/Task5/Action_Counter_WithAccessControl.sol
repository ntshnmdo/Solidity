// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ActionCounter {

    mapping(address => uint256) public actionCount;

    address public owner; // stores contract admin

    event ActionPerformed(address user, uint256 newCount);
    event CounterReset(address user);

    error NotOwner();
    error NoActionsToReset();

    constructor() {
        owner = msg.sender; // Deployer becomes owner
    }

    modifier onlyOwner() { // only owner can call certain function
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _; // continue execution
    }

    // User increments their own counter
    function performAction() public {
        uint256 count = actionCount[msg.sender];
        count++;
        actionCount[msg.sender] = count;

        emit ActionPerformed(msg.sender, count);
    }

    // User resets their own counter
    function resetMyCounter() public {
        if (actionCount[msg.sender] == 0) {
            revert NoActionsToReset();
        }

        actionCount[msg.sender] = 0;

        emit CounterReset(msg.sender);
    }

    // Owner can reset ANY user's counter
    function resetUserCounter(address user) public onlyOwner {
        if (actionCount[user] == 0) {
            revert NoActionsToReset();
        }

        actionCount[user] = 0;

        emit CounterReset(user);
    }
}