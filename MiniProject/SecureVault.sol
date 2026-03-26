// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SecureVault {

    
    // State Variables(Storage):
    // stores user balances
    // key = user address
    // value = ETH deposited
    
    mapping(address => uint256) public balances;
    address public owner; // stores contract owner

    bool private locked; // used for reentrancy protection
    // prevents function from being called again during execution

    
    // Events
    // events are used to record actions on blockchain

    event Deposit(address indexed user, uint amount);
    event Withdraw(address indexed user, uint amount);
    event EmergencyWithdraw(address indexed owner, uint amount);

    
    // Constructor
    // runs once at deployment
    // msg.sender = deployer
    // sets the owner
    constructor() {
        owner = msg.sender;
    }

    
    // Modifiers
    // restricts function access. only owner can call functions

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrancy detected"); // prevents reentrancy attacks
        locked = true;
        _;
        locked = false;
    }

    
    // Deposit ETH
    // payable: allows receivig ETH
    // msg.value: ETH sent

    function deposit() public payable {
        require(msg.value > 0, "Send ETH"); // prevents empty deposits

        balances[msg.sender] += msg.value; // update balances

        emit Deposit(msg.sender, msg.value); // logs deposits
    }

    
    // Withdraw ETH
    // -----------------------

    function withdraw(uint amount) public nonReentrant {
        // user must have enough balance
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // EFFECT: CEI pattern: Update state before sending ETH.
        balances[msg.sender] -= amount;

        // INTERACTION: sends ETH, uses low-level calls, recommednd over transfer
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed"); // check transfer

        emit Withdraw(msg.sender, amount);
    }

    
    // Owner Emergency Withdraw: transfers all contract ETH to owner
    // -----------------------

    function emergencyWithdraw() public onlyOwner {
        uint amount = address(this).balance; // get contract balance
        
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed"); 

        emit EmergencyWithdraw(owner, amount);
    }
        
        

    
    // Receive ETH
    // triggered when ETH sent directly to contract

    receive() external payable {
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);

        // direct transfer = deposit.
    }

}