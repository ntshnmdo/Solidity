/*
int/ uint

integer types

uint8 = 0 to 2^8 -1 = 255
uint256 = 0 to 2^256 - 1

int8 = -128 to 127
*/

/*
address: stores an eth account or contract address.
*/

contract Wallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
}

/*
property           Description
-------------------------------------------
msg.sender         address of the caller
msg.value          ETH sent with transaction
balance            ETH balance of address
*/

/*
bytes32: stores fixed size binary data (32 bytes)

often used for:
- hashes
- identifiers
- encoded data

*/

contract HashExample {
    bytes32 public data;

    function setData(string memory text) public {
        data = keccak256(abi.encodePacked(text));
    }
} 

/*
why bytes32 is common
- gas efficient
- fixed length
- ideal for cryptographic hashes
*/

/*
enum - creates custom data types with predefined values
*/

contract Order {
    enum Status {
        pending,
        shipped,
        delivered
    }

    Status public orderStatus;

    function ship() public {
        orderStatus = Status.Shipped;
    }
}