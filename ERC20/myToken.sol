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
    
    address public owner; // contract controller (admin)

    mapping(address => uint256) public balanceOf;  // stores tokens per user; ex: 0xABC → 500 tokens
    mapping(address => mapping(address => uint256)) public allowance; // owner (mapping to) → spender (mapping to) → amount
    // ex; Alice → Bob → 100 tokens; Bob can spend 100 tokens from Alice.
    
    // whitelist & blacklist
    mapping(address => bool) public whitelist; // allowed users
    mapping(address => bool) public blacklist; // blocked users

    // EVENTS: useful in frontend, dApps, used by wallets, tracks transaction
    // transfer: must trigger when tokens are transferred, including 0 value transfer.
    // approval: must trigger on any successful call to approve
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

     // events for tracking
    event Whitelisted(address user);
    event Blacklisted(address user);

    // only contract owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner"); 
        _;
    }

    // CONSTRUCTOR (mint initial supply)
    constructor(uint256 _initialSupply) {
        owner = msg.sender; // owner is set

        totalSupply = _initialSupply * (10 ** decimals); // total supply is created 
        balanceOf[msg.sender] = totalSupply; // all tokens goto owner
        
        // Owner should be whitelisted by default
        whitelist[msg.sender] = true;

        emit Transfer(address(0), msg.sender, totalSupply); // mint event: address(0) means minting

        /* On deployment:
        if we pass: 1000 
        then, totalSupply = 1000 * 10^18
        and all tokens go to: msg.sender (deployer)

        why Transfer(address(0),...) ?
        this means: Tokens are "minted".
        */
    }

    // Add to whitelist: only owner can allow users
    function addToWhitelist(address user) public onlyOwner {
        whitelist[user] = true; // owner allows user to send / receive tokens
        emit Whitelisted(user); // logging out
    }

    // Remove from whitelist
    function removeFromWhitelist(address user) public onlyOwner {
        whitelist[user] = false;
    }

    // Add to blacklist: blocks users
    function addToBlacklist(address user) public onlyOwner {
        blacklist[user] = true;
        emit Blacklisted(user);
    }

    // Remove from blacklist
    function removeFromBlacklist(address user) public onlyOwner {
        blacklist[user] = false;
    }
    
    // INTERNAL CHECK
    function _checkAccess(address from, address to) internal view {
        require(whitelist[from], "Sender not whitelisted");
        require(whitelist[to], "Receiver not whitelisted");

        require(!blacklist[from], "Sender blacklisted");
        require(!blacklist[to], "Receiver blacklisted");
    }

    // TRANSFER: transfers _value amount of tokens to address _to and must fire transfer event.
    function transfer(address to, uint256 amount) public returns (bool) {
        _checkAccess(msg.sender, to);
        require(balanceOf[msg.sender] >= amount, "Not enough tokens"); // check balance

        balanceOf[msg.sender] -= amount; // update balances
        balanceOf[to] += amount; // added to receivers balance

        emit Transfer(msg.sender, to, amount); // logging out in off chain
        return true; // confirmation indicator
        // ex: Alice → Bob (100 tokens)
    }

    // APPROVE: allows spender to withdraw from your account multiple times, up to the value amount.
    // and allows to spend your tokens
    function approve(address spender, uint256 amount) public returns (bool) {
        require(!blacklist[msg.sender], "Blacklisted");
        allowance[msg.sender][spender] = amount; // Alice approves Bob → 50 tokens

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // TRANSFER FROM: transfers value amount of tokens from address _from to address _to.
    // This allows approved spender to move tokens.
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        _checkAccess(from, to);
        
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
// approval risk: there can be front run so set allowance value to 0 first, then set new value
// so that no old allowance can be used 