/* vulnerable code
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Vulnerable {

    mapping (address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint amount = balances[msg.sender];
        require(amount > 0);
        (bool success,) = msg.sender.call{value: amount}(""); // Vulnerable line
        require(success);

        balances[msg.sender] = 0;
    }
}

// aatacker can reenter before balances[msg.sender] = 0
*/

/*
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeCEI {

    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {

        uint amount = balances[msg.sender];

        require(amount > 0);

        balances[msg.sender] = 0; // EFFECT first

        (bool success,) = msg.sender.call{value: amount}(""); // interaction
        require(success);
    }
}

//Now reentrancy fails because balance becomes 0 before external call.
*/

/*
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReentrancyGuardExample {

    bool private locked;

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public nonReentrant {

        uint amount = balances[msg.sender];
        require(amount > 0);

        balances[msg.sender] = 0;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
    }
}

Now reentrancy cannot happen because:
locked = true
prevents the second call.
*/

/*
Even if withdraw() is protected, attacker might reenter another function.

contract CrossFunction {

    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {

        uint amount = balances[msg.sender];

        (bool success,) = msg.sender.call{value: amount}("");
        require(success);

        balances[msg.sender] = 0;
    }

    function transfer(address to, uint amount) public {

        require(balances[msg.sender] >= amount);

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

withdraw()
  ↓
fallback()
  ↓
call transfer()

Balance still exists → exploit possible.
*/

/*
Real-World Reentrancy Attack Pattern
Typical exploit contract:

contract Attacker {

    address victim;

    constructor(address _victim) {
        victim = _victim;
    }

    fallback() external payable {
        if(address(victim).balance >= 1 ether) {
            victim.call(abi.encodeWithSignature("withdraw()"));
        }
    }

}

This loops withdrawals.
*/