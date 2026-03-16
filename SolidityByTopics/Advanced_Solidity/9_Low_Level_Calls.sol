/*
Low-level calls are used in proxies, upgradeable contracts, DeFi integrations, and contract-to-contract communication.

We’ll cover:
call
delegatecall
staticcall
Differences
Risks
Remix practice code

Low-Level Calls
Solidity provides high-level calls like:
token.transfer(...)

But sometimes you need low-level control.
That’s where low-level calls come in.
They are part of the EVM message call system.

1. call
call is the most common low-level function.
It is used to:
call another contract
send ETH
execute a function dynamically

syntax:
(bool success, bytes memory data) = address(target).call(
    abi.encodeWithSignature("functionName(uint256)", value)
);

Example: call a function
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Target {

    uint public number;

    function setNumber(uint _num) public {
        number = _num;
    }
}

contract Caller {

    function callSetNumber(address _target, uint _num) public {
        (bool success, ) = _target.call(
            abi.encodeWithSignature("setNumber(uint256)", _num)
        );

        require(success, "Call failed");
    }
}

The target contract executes its own code and storage.

Sending ETH with call
Modern way to send ETH:

(bool success, ) = payable(receiver).call{value: 1 ether}("");
require(success, "Transfer failed");

This replaced:
transfer()
send()
because they have gas limitations.

2. delegatecall
delegatecall is extremely important.
It executes code from another contract, but uses the caller’s storage.

(bool success, ) = implementation.delegatecall(msg.data);

Key idea
delegatecall → execute code of another contract
BUT use storage of the calling contract

Example
Implementation contract:
contract Logic {

    uint public number;

    function setNumber(uint _num) public {
        number = _num;
    }
}

Proxy contract:
contract Proxy {

    uint public number;
    address public implementation;

    constructor(address _impl) {
        implementation = _impl;
    }

    function setNumber(uint _num) public {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("setNumber(uint256)", _num)
        );

        require(success);
    }
}

Flow:
User → Proxy → Logic code executes
BUT Proxy storage is updated

This is how upgradeable proxies work.

3. staticcall
staticcall is used for read-only calls.

It guarantees:
NO state changes

If the called function tries to modify state → transaction fails.

Syntax:
(bool success, bytes memory data) = address(target).staticcall(
    abi.encodeWithSignature("getValue()")
);

Example:
contract Reader {

    function readNumber(address target) public view returns(uint) {

        (bool success, bytes memory data) =
            target.staticcall(
                abi.encodeWithSignature("number()")
            );

        require(success);

        return abi.decode(data, (uint));
    }
}

Used heavily by:
oracles
off-chain simulation
frontend queries

Comparison:
| Feature            | call                  | delegatecall    | staticcall        |
| ------------------ | --------------------- | --------------- | ----------------- |
| Execute code       | target contract       | target contract | target contract   |
| Storage used       | target storage        | caller storage  | target storage    |
| ETH transfer       | yes                   | no              | no                |
| State modification | yes                   | yes             | ❌ no             |
| Used for           | normal contract calls | proxies         | read-only queries |

Visual Understanding:
call
Caller → Target
Target code
Target storage

delegatecall
Caller → Implementation code
Caller storage

staticcall
Caller → Target
Read only

Security Risks

Low-level calls are dangerous.

1. Reentrancy risk

Using call to send ETH can allow reentrancy.

Example attack:
DAO Hack

Always follow:
Checks
Effects
Interactions

2. delegatecall storage collision

If storage layouts don't match:
Proxy storage gets corrupted

Example:
slot 0 mismatch

3. call does NOT revert automatically

Unlike normal Solidity calls.

You must check:
require(success);

# Low-level calls are used in:
Proxy contracts
Upgradeable contracts
Meta-transactions
DeFi protocol integrations
Dynamic contract interaction
Fallback proxy forwarding

# One very important concept

The fallback proxy pattern:

fallback() {
   delegatecall(implementation)
}

This powers almost all upgradeable smart contracts.

*/