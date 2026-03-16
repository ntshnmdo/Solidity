/*
Now it is clean architecture + gas optimization territory

Libraries are heavily used in:

OpenZeppelin
DeFi protocols
Math operations
Safe transfers
Utility functions

Libraries: Internal / External Libraries & using for

What is a Library?
A library is a reusable collection of functions.

Key properties:
Cannot hold state (no storage variables)
Cannot receive ETH
Cannot be destroyed
Used to share reusable logic
Improves modularity
Saves deployment gas (when external)
Think of it like a utility helper contract.

Basic library example:

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library MathLib {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a+b;
    }
}

now using it 

contract calculator {
    function sum(uint256 a, uint256 b) public pure returns (uint256) {
        return MathLib.add(a, b);
    }
}

#Internal Library

Functions marked internal:
function add(uint256 a, uint256 b) internal pure returns (uint256)

What happens?
Code is copied directly into contract.
Similar to inheritance.
No separate deployment.
Cheaper call cost.
Larger contract size.
Internal libraries behave like inline code.

#External Library

Functions marked public or external:
function add(uint256 a, uint256 b) public pure returns (uint256)

What happens?
Library must be deployed separately.
Contract makes DELEGATECALL to library.
Saves contract bytecode size.
Better for large reusable logic.
External libraries reduce contract size.

#delegatecall in External Libraries

When calling external library:
Code executes in context of calling contract.
Storage belongs to calling contract.
Library cannot store state.
This is why libraries are safe reusable logic blocks.

#The using for Keyword

This allows attaching library functions to types.

🔹 Without using for
uint256 result = MathLib.add(a, b);

🔹 With using for
using MathLib for uint256;
uint256 result = a.add(b);

Now library function behaves like a method of uint256.
Cleaner and more readable.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library MathLib {
    function add(uint256 self, uint256 b) internal pure returns (uint256) {
        return self + b;
    }
}

contract Test {
    using MathLib for uint256;

    function calculate(uint256 x, uint256 y) public pure returns(uint256) {
        return x.add(y);
    }
}

// self becomes 1st parameter
// x.add(y) -> internally calls add(x,y)
// THis pattern is heavily used in OpenZeppelin.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library ArrayLib {
    function sum(uint256[] memory arr) internal pure returns (uint256 total) {
        for (uint i = 0; i < arr.length; i++) {
            total += arr[i];
        }
    }
}

contract TestArray {
    using ArrayLib for uint256[];

    function getSum(uint256[] memory arr) public pure returns(uint256) {
        return arr.sum();
    }
}
// now arrays have a .sum() function.
/*
When to Use Libraries
Use libraries when:
Writing reusable logic.
Writing math utilities.
Handling array operations.
Validating data.
Writing complex internal logic.
Avoiding duplicate code.

Do NOT use libraries when:
You need persistent storage.
You need ownership logic.
You need state.

Libraries are stateless.

Gas & Deployment Tradeoffs
Type	    Deployment	               Gas Usage	         Contract Size
Internal	No separate deploy	       Cheaper calls	     Larger bytecode
External	Separate deploy	Slightly   higher call cost	     Smaller bytecode
If library is used in many contracts → external is better.

OpenZeppelin Libraries (Industry Standard)

Common library usage:
SafeERC20
Address
Strings
ECDSA
Counters

OpenZeppelin heavily uses using for.
*/