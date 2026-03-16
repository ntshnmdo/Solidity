// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


contract Primitives {
    bool public boo = true;

    /*
    uint stands for unsigned integer, meaning "non-negative whole number"
    different sizes are available
        uint8 ranges from 0 to 2**8-1
        uint16 ranges from 0 to 2**16-1
        ...
        uint256 ranges from 0 to 2**256-1
    */

    uint8 public u8 = 1;
    uint256 public u256 = 456;
    uint256 public u = 123; // uint is an alias for uint256 ( uint == uint256 )

    /*
    Negative numbers are allowed for int types.
    like uint, ints have different sizes:

    int256 ranges from -2**255 to 2**255 - 1
    int128 ranges from -2**127 to 2**127 - 1
    */

    int8 public i8 = -1;
    int256 public i256 = 456;
    int256 public i = -123; // int is same as int256

    // minimum and maximum of int 
    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    address public addr =  0xb4115A1e2f337a8036bCf08319b6E2D7c6B5fDE4;

    /*
    in solidity, the data type byte represent a sequence of bytes, which is similar to bytes1[].
    solidity represents two types of bytes:

    -fixed-sized byte arrays
    -dynamically-sized byte arrays

    the term bytes in solidity represents a dynamic array of bytes.
    its a shorthand for byte[].
    */

    bytes1 a = 0xb5; // [10110101]
    bytes1 b = 0x56; // [01010110]

    // default values
    // unsigned variables have a default value

    bool public defaultBoo; // false
    uint256 public defaultUint; // 0
    int256 public defaultInt; // 0
    address public defaultAddr; // // 0x0000000000000000000000000000000000000000

    event LogValues (
        bool boo,
        uint256 u,
        int256 i,
        address addr

    );

    function printValues() public {
        emit LogValues(boo, u, i, addr);
    }
}