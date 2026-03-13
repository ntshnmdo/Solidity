/*
variables are declared as either storage, memory, or calldata to explicitly specify the location of the data.

- storage: variable is state variable (store on blockchain)
- memory: variable is in memory and it exists while a function is being called
- calldata: special data location that contains function arguments. It is used to pass arguments to a function. It is a non-modifiable, non-persistent area where function arguments are stored
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DataLocations {
    uint256[] public arr; // storage
    mapping(uint256 => address) map;

    struct MyStruct {
        uint256 foo;
    }

    mapping(uint256 => MyStruct) myStructs;

    function f() public {
        // call _f with state variables
        _f(arr, map, myStructs[1]);

        // get a struct from a mapping
        MyStruct storage myStruct = myStructs[1];
        // create a struct in memory
        MyStruct memory myMemStruct = MyStruct(0);
    }

    function _f(
        uint256[] storage _arr,
        mapping(uint256 => address) storage _map,
        MyStruct storage _myStruct
    ) internal {
        // do something with storage variables 
    }

    // you can return memory variables
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // do something with memory array
    }

    function h(uint256[] calldata _arr) external {
        // so something with calldata array
    }
}