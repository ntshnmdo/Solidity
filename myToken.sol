// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
This contract implements a basic ERC20 token where users can hold, transfer, and 
approve others to spend tokens on their behalf. It uses mappings to store balances 
and allowances, and emits events to track transfers and approvals.
*/
contract MyToken {
    
    // Token MetaData
    string public name = "MyToken"; // token name
    string public symbol = "MTK"; // short form
    uint8 public decimals = 18; // for precision

    // 1 token = 10^18 units

    uint256 public totalSupply; // stores total number of tokens in existence.

    mapping(address => uint256) public balanceOf;  // ex; 0xABC → 500 tokens

    mapping(address => mapping(address => uint256)) public allowance; // owner (mapping to) → spender (mapping to) → amount
    // ex; Alice → Bob → 100 tokens; Bob can spend 100 tokens from Alice.


    // EVENTS: useful in frontend, dApps, used by wallets, tracks transaction
    // transfer: must trigger when tokens are transferred, including 0 value transfer.
    // approval: must trigger on any successful call to approve
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // CONSTRUCTOR (mint initial supply)
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * (10 ** decimals);
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);

        /* On deployment:
        if we pass: 1000 
        then, totalSupply = 1000 * 10^18
        and all tokens go to: msg.sender (deployer)

        why Transfer(address(0),...) ?
        this means: Tokens are "minted".
        */
    }

    // TRANSFER: transfers _value amount of tokens to address _to and must fire transfer event.
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Not enough tokens"); // check balance

        balanceOf[msg.sender] -= amount; // update balances
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
        // ex: Alice → Bob (100 tokens)
    }

    // APPROVE: allows spender to withdraw from your account multiple times, up to the value amount.
    // and allows to spend your tokens
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount; // Alice approves Bob → 50 tokens

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // TRANSFER FROM: transfers value amount of tokens from address _from to address _to and must fire 
    // This allows approved spender to move tokens.
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Not enough tokens"); // check balance
        require(allowance[from][msg.sender] >= amount, "Not allowed"); // check allowance

        allowance[from][msg.sender] -= amount; // reduce allowance
        
        // transfers tokens
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }
}

// no reentrancy risk here bcz no ETH transfer
// approval risk: can be front run so set value to 0 first, then set new value