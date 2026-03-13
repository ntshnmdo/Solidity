// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract EventExample {

    event Deposit(address user, uint amount);

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }
}

/*
contract Token {

    event Transfer(address indexed from, address indexed to, uint amount);

    function send(address to, uint amount) public {
        emit Transfer(msg.sender, to, amount);
    }
}

this pattern is used in ERC20 tokens
*/

/*
contract Example {

    uint public totalDeposits;

    event Deposit(address user, uint amount);

    function deposit() public payable {

        totalDeposits += msg.value;

        emit Deposit(msg.sender, msg.value);
    }
}

what happened:
state
totalDeposits -> stored in contract storage

event log
Deposit(user, amount)

used for tracking transactions externally.
*/

/*
events are heavily used in:

- token transfer
- NFT minting
- DeFi transactions
- Governance voting

Example ERC20 pattern:

Transfer(from, to, amount)
Approval(owner, spender, amount)
*/