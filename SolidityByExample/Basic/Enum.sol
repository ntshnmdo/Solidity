// Solidity supports enumerables and they are useful to model choice and keep track of state.
// enum can be declared outside of a contract.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Enum {
    // enum representing shipping status
    enum Status {
        pending,
        shipped,
        accepted,
        rejected,
        canceled
    }

    // default value is the first element listed in definition of the type, in this case "pending"
    Status public status;

    // returns uint
    // pending 0
    // shipped 1
    // accepted 2
    // rejected 3
    // canceled 4
    function get() public view returns (Status) {
        return status;
    }

    // update status by passing uint into input
    function set(Status _status) public {
        status = _status;
    }

    // you can update to a specific enum like this
    function cancel() public {
        status = Status.canceled;
    }

    // delete resets the enum to its first value, 0
    function reset() public {
        delete status;
    }
}

/*
#declaring and importing enum
file that the enum is delared in.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
// this is saved 'EnumDeclaration.sol'

enum Status {
    Pending,
    Shipped,
    Accepted,
    Rejected,
    Canceled
}

# file that imports the enum above.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./EnumDeclaration.sol";

contract Enum {
    Status public status;
}
*/