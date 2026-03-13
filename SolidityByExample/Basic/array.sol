// array can have a compile-time fixed size or a dynamic size.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Array {
    // several ways to initialize an array
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];
    // fixed size array, all elements initialize to 0
    uint256[10] public myFixedSizeArr; // fixed size array

    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    // Solidity can return the entire array.
    // But this function should be avoided for arrays that can grow indefinitely in length.
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function push(uint256 i) public {
        // append to array
        // this will increase the array length by 1.
        arr.push(i);
    }

    function pop() public {
        // removes the last element from array
        // this will decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns (uint256) {
        return arr.length;
    }

    function remove(uint256 index) public {
        // delete doesnot change the array length
        // it resets the value at index to its default value,
        // in this case 0
        delete arr[index];
    }

    function examples() external pure {
        // create array in memory, only fixed size can be created
        uint256[] memory a = new uint256[](5);
    }
}
