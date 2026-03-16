// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Target {

    uint public number;

    function setNumber(uint _num) public {
        number = _num;
    }
}

contract LowLevelCaller {

    function callSet(address target, uint _num) public {

        (bool success, ) = target.call(
            abi.encodeWithSignature("setNumber(uint256)", _num)
        );

        require(success);
    }
}