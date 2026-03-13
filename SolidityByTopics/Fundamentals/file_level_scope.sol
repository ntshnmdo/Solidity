/*
at the file level, you can define elements that are accessible throughout the file.

THings that can exitst at file level.
1. contracts
2. libraries
3. interfaces
4. structs
5. enums
6. custom errors
7. user defined value types
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

struct User {
    uint id;
    string name;
}

error NotAuthorized(); 
/*
defines a custom error in Solidity.
It declares an error named NotAuthorized that can be used to revert a transaction when a user is not allowed to perform an action.

It does not execute anything by itself.
It only defines the error, which can later be used with revert.
Introduced in Solidity 0.8.4 to save gas compared to require.
*/

contract MyContract {
    User public user;

    function setUser(uint _id, string memory _name) public {
        user = User(_id, _name);
    }
}