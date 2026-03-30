// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//IArbitrator: Interface for arbitrator contracts,
// defines how your marketplace talks to an arbitrator.

interface IArbitrator {
    function notifyDispute(uint256 orderId) external;  // this defines function, no implementation
}

//external: interfaces only use external function, they are meant to be called from other contracts.

// MockArbitrator: Simple implementation of IArbitrator for testing (actual logic)

contract MockArbitrator is IArbitrator {   // is IArbitrator: Inheritance, implements all functions in the interface

    // Event to track disputes: logs when disputes is triggered
    event DisputeNotified(uint256 indexed orderId, address indexed caller);

    //Called by EscrowMarketplace when a dispute is opened

    function notifyDispute(uint256 orderId) external override {   // override: required because you are implementing an interface function
        emit DisputeNotified(orderId, msg.sender);
    }
}