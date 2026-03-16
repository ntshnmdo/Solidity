// Mulitple Inheritance: Solidity allows inheriting from multiple contracts.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    function foo() public pure virtual returns(string memory) {
        return "A";
    }
}

contract B {
    function foo() public pure virtual returns(string memory) {

    }
}

contract C is A, B {
    function foo() public pure override(A, B) returns(string memory) {
        return "C";
    }
}

/*
C inherits A and B
both A and B have foo()
we must override explicitly
*/

/*
3. Vitual and Override

solidity forces explicit override for safety 

Rule 1: Parent must use virtual 
function foo() public virtual returns(string memory)

Rule 2: Child must use override
function foo() public override returns(string memory)

Multiple parents:
if two parents define same fucntion:
override(A, B)

you must specify both
this prevents accidental behavior conflicts.
*/

// super keyword: super calls the next fucntion in inheritance chain.

/*
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

contract C is B {
    function foo() public pure override returns(string memory) {
        return string.concat(super.foo(), " -> C");
    }
}

Calling C.foo() returns
A -> B -> C
super follows inheritance orders
*/

/*
5. C3 Linearization 

when multiple inheritance exists, solidity must decide:
in what order to search parent contracts?

solidity uses C3 linearization

 what C3 linearization does?
 it defines a deterministic order of inheritance resolution

 rule:
 solidity resolves from right to left

 contract C is A, B

 inheritance order:
 1. C
 2. B
 3. A

right most parent is prioritized
*/

/*
Diamond Problem in Solidity

    A
   / \
  B   C
   \ /
    D

if both B and C inherit A, and D inherits B & C
Which A is used?

C3 Linearization ensures:
only one A
deterministic order 
no duplication
*/

