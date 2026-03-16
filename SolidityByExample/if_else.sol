// used to execute code based on conditions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract IfExample {

    function checkNumber(uint num) public pure returns(string memory) {

        if (num > 10) {
            return "Greater than 10";
        }
        else if (num == 10) {
            return "Equal to 10";
        }
        else {
            return "Less than 10";
        }
    }
}