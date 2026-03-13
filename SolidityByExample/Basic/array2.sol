// removing array element by copying last element into the place to remove.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ArrayReplaceFromEnd {
    uint256[] public arr;

    function remove(uint256 index) public {
        // move the last ele into place to delete
        arr[index] = arr[arr.length-1];
        // remove last ele
        arr.pop();
    }

    function test() public {
        arr = [1,2,3,4];

        remove(1);
        // [1,4,3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        remove(2);
        // [1,4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
 }  