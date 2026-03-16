/*
Interfaces are foundational for:
Calling external contracts
Interacting with ERC20 / ERC721
DeFi protocol integrations
Upgradeable patterns
Proxy systems

# Interfaces: External Contracts & ERC Interfaces

# What is an Interface?

An interface is a contract-like structure that:

-Defines function signatures
-Contains NO implementation
-Cannot have state variables
-Cannot have constructors
-All functions must be external
-It is like a blueprint for interaction.


*/

// basic syntax

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICounter {
    function increment() external;
    function getCount() external view returns (uint256);

}

// Notice:
// - only function declaration
// - no function body {}

/*
# Why Do We Need Interfaces?

When interacting with another deployed contract:
You don’t need its full code.
You only need:
Its function signatures
ABI-compatible structure
Interfaces allow:
Talking to external contracts without importing full implementation.
*/

/*
Calling External Contracts Using Interface

Step 1: Create Target Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint256 public count;

    function increment() external {
        count++;
    }
}
Deploy this first in Remix.

Step 2: Create Interface
interface ICounter {
    function increment() external;
    function count() external view returns (uint256);
}

Step 3: Use Interface in Another Contract
contract CounterCaller {

    function callIncrement(address _counterAddress) public {
        ICounter(_counterAddress).increment();
    }

    function readCount(address _counterAddress) public view returns(uint256) {
        return ICounter(_counterAddress).count();
    }
}

Now:

Deploy Counter
Deploy CounterCaller
Pass Counter address into functions
Caller interacts with Counter via interface
This is how DeFi protocols interact with tokens.

# Interface vs Import
Import
Imports full contract code.

Interface
Imports only function signatures.

Best practice:
Use interface when interacting with deployed contracts.
Don’t import full implementation unnecessarily.

# ERC Interfaces (Very Important)

Most tokens follow standards.

Example:
ERC-20
ERC-721

These standards define required functions.

# ERC20 Interface Example
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
This is the official structure tokens must implement.
}

# Interacting with ERC20 Token (Practice)
🔹 Example: Token Vault

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract TokenVault {

    function deposit(address tokenAddress, uint256 amount) public {
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
    }
}

Flow:
User approves TokenVault contract
Vault calls transferFrom
Tokens move to Vault
This is how staking contracts work.

# Why Functions Must Be external in Interfaces
Interfaces describe:
External communication only.
They are not meant for internal logic.
All interface functions are implicitly virtual.

#Multiple Inheritance with Interfaces
You can inherit multiple interfaces.

interface IA {
    function foo() external;
}

interface IB {
    function bar() external;
}

contract MyContract is IA, IB {
    function foo() external override {}
    function bar() external override {}
}

Common in standards like ERC721.

#Interface vs Abstract Contract
Interface	                Abstract Contract
Only function signatures	Can include implemented functions
No state variables	        Can have state variables
All functions external	    Any visibility allowed
No constructor	            Can have constructor

Use interface for external protocol interaction.
Use abstract contract for shared logic patterns.

# Real World Usage

DeFi contracts rarely know:
Internal implementation of tokens
Internal logic of other protocols

They rely on:
Standard interfaces
ABI compatibility

Example:
DEX contract interacts with any ERC20 token using IERC20 interface.

*/
