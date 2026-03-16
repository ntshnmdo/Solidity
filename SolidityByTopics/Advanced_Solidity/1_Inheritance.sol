/* In solidity Inheritance is 
Inheritance allows a contract to inherit the properties and functions of another contract. This promotes code reusability and modularity.
it works similar to OOP in Java/ Cpp/ Python.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Animal {
    string public species;

    function setSpecies(string memory _species) public {
        species = _species;
    }
}

contract Dog is Animal {
    function bark() public pure returns(string memory) {
        return "Woof!";
    }
 }

/*
Dog inherits from Animal
Dog can use setSpecies()
Dog can access species

Inheritance keywords:
contract Child is Parent
 */

