/*
solidity supports for, while, and do while loops

dont write loops that are unbounded as this can hit the gas limit, causing your transaction to fail. 
for this reason, while and do while loops are rarely used.these are unbounded
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Loop {
    function loop() public pure {
        // for loop 
        for (uint256 i = 0; i < 10; i++) {
            if (i==3) {
                // skip to next iteration with continue
                continue;
            }
            if (i==5) {
                // exit loop with break
                break;
            }
        }

        // while loop
        uint256 j;
        while (j<10) {
            j++;
        }
    }
}