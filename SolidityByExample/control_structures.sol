// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ControlExample {

    function test(uint n) public pure returns(uint) {

        uint sum = 0;

        if (n == 0) {
            return 0;
        }

        for (uint i = 1; i <= n; i++) {

            if (i == 5) {
                break;
            }

            if (i%2 == 0) {
                continue;
            }

            sum += i;
        }

        return sum;
    }
}