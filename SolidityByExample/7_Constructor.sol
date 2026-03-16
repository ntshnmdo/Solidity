/*
A constructor is a special function that runs only once when the smart contract is deployed. It is used to initialize the contract state.

constructor() {
    // initialization code here
}
After deployment, the constructor cannot be called again.

# Why Do We Use Constructors?
Constructors are used to:
1️⃣ Set initial values for variables
2️⃣ Assign ownership of a contract
3️⃣ Initialize important contract settings
4️⃣ Run setup logic during deployment

# Example 1 – Setting Initial Value

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Example {

    uint public number;

    constructor() {
        number = 10;
    }
}

When the contract is deployed:
number = 10
The constructor sets the initial value.

# Example 2 – Owner Assignment (Very Common)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Ownable {

    address public owner;

    constructor() {
        owner = msg.sender;
    }
}

Here:
msg.sender = person deploying the contract
So the deployer becomes the owner.
This pattern is used in almost every real smart contract.

# Example 3 – Passing Parameters to Constructor
You can pass arguments during deployment.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Token {

    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

When deploying in Remix:
Input: "MyToken"

Now:
name = MyToken

# Important Properties of Constructor
Property	              Explanation
Runs once	              Only during deployment
Cannot be called again	  After deployment it disappears
Used for initialization	  Sets initial state
Optional	              Contract can exist without it

# What Happens After Deployment?
The constructor code is not stored on the blockchain.
Only the runtime bytecode of the contract remains.

So after deployment:
constructor() → removed

This saves gas and storage.

# Example Flow
Deploy contract
        ↓
constructor() executes
        ↓
initial variables set
        ↓
contract becomes active

# Real-World Uses
Constructors are commonly used for:
Setting contract owner
Initializing token supply
Configuring oracle addresses
Setting admin roles
Initializing proxy contracts
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// base contract X
contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

// base contract Y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// there are 2 ways to initialize parent contract with parameters.
// pass the parameters here in the inheritance list.

contract B is X("Input to X"), Y("Input to Y") {}

contract C is X, Y {
    // pass the parameters here in the constructor,
    // similar to function modifier.
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

// parent constructors are always called in the order of inheritance
// regardless of the order of parent contracts listed in the constructor of the child contract.

// order of constructor called:
// 1. X
// 2. Y
// 3. D

contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

// order of constructor called:
// 1. X
// 2. Y
// 3. E

contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}