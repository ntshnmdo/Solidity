// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    function foo() public pure virtual returns(string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure virtual override returns(string memory) {
        return string.concat(super.foo(), " -> B");
    }
}

contract C is A {
    function foo() public pure virtual override returns(string memory) {
        return string.concat(super.foo(), " -> C");
    }
}

contract D is B, C {
    function foo() public pure override(B, C) returns(string memory) {
        return string.concat(super.foo(), " -> D");
    }
}

// output will be: 
// A -> C -> B -> D
// why ? because solidity resolves right to left:
// D -> C -> B -> A 
// this is C3 linearization in action

/*
imp rules 

order matters
contract D is B, C

is different from:
contract D is C, B

✅ Constructors also follow linearization order
Parent constructors execute automatically in linearized order.

✅ State variables are shared
If parent defines:
uint public x;

Child inherits it.
*/