// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ActionCounter {

    // Store action count per user
    mapping(address => uint256) public actionCount;

    // Event
    event ActionPerformed(address user, uint256 newCount);

    // Custom error (gas efficient)
    error NoActionsToReset();

    // Increment counter
    function performAction() public {   
        // Gas optimization: use local variable
        uint256 count = actionCount[msg.sender];

        count++;

        actionCount[msg.sender] = count;

        emit ActionPerformed(msg.sender, count);
    }

    // Reset counter
    function resetMyCounter() public {
        if (actionCount[msg.sender] == 0) {
            revert NoActionsToReset();
        }

        actionCount[msg.sender] = 0;
    }
}