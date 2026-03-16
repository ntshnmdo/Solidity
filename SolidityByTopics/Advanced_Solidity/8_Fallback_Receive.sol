/*
imp topic low-level solidity topic

fallback and receive are deeply connected to:
- ETH reception: If someone sends ETH to a contract:The contract must know how to receive it. In Solidity, this is done using: 1️⃣ receive() 2️⃣ fallback()
- low-level calls
- proxy contracts
- upgradable contracts
- delegatecall mechanics

ETH Reception + Proxy Implications

# Why Do Fallback & Receive Exist?

When ETH or data is sent to a contract:
What function should run?

Solidity provides two special functions:
1️⃣ receive()
2️⃣ fallback()

They handle cases when:
- ETH is sent without function call
- Nonexistent function is called
- Raw calldata is sent
*/

/*
# receive() Function

receive() external payable {
}

🔹 When Does It Trigger?

It executes when:
ETH is sent
AND calldata is empty

Example:
address(contract).call{value: 1 ether}("");

No data → receive() runs.
*/

/*
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReceiveExample {
    
    event Received (address sender, uint amount);

    receive() external payable {
        emit Received (msg.sender, msg.value);
    } 
}
*/

/*
# fallback() Function

fallback() external payable {
}

🔹 When Does It Trigger?

It runs when:
Function does not exist
OR calldata is not empty
OR receive() doesn’t exist

Example:

Calling a non-existent function:

contract.call(abi.encodeWithSignature("doesNotExist()"));

Fallback runs.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FallbackExample {
    
    event FallbackCalled(address sender, uint value);

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value);
    }
}
*/

/*
# receive vs fallback Priority

If both exist:

Situation	                Function Triggered
ETH + empty calldata	    receive()
ETH + non-empty calldata	fallback()
No ETH + unknown function	fallback()

receive() has priority over fallback().

# Why This Matters for ETH Reception
If your contract has no payable function:
Sending ETH will revert.

If fallback exists but not payable:
Sending ETH will revert.

To receive ETH safely:
You need payable
Either receive or fallback must handle it

6️⃣ Dangerous Behavior (Security Risk)
If you unintentionally leave fallback payable:
Anyone can send ETH.

If your contract logic assumes no ETH is stored:
This may break assumptions.
Always design ETH reception explicitly.

7️⃣ Proxy Implications (VERY IMPORTANT)
Now the advanced part 🔥
Fallback is the heart of proxy contracts.

8️⃣ What Is a Proxy?
A proxy contract:
Has minimal logic.
Delegates all calls to another contract (implementation).
Enables upgradeability.

Core idea:

fallback() external payable {
    delegatecall(implementation, msg.data)
}

All unknown function calls are forwarded.

9️⃣ delegatecall + fallback

delegatecall:
-Executes code from another contract.
-Uses proxy’s storage.
-Preserves msg.sender and msg.value.

Proxy pattern works because fallback catches all calls.
*/


/*
# Minimal Proxy Example

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Proxy {

    address public implementation;

    constructor(address _impl) {
        implementation = _impl;
    }

    fallback() external payable {
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success);
    }
}

-Any function not found in Proxy
-Goes to fallback
-Gets delegated to implementation

# Why This Is Powerful

Proxy allows:
Upgrading logic without changing address
Keeping storage intact
Fixing bugs in deployed contracts

Used in:
OpenZeppelin Upgradeable
DeFi protocols
DAOs
ERC1967 proxies

# Security Risks of Fallback
🚨 Risk 1 – Unintended Execution
If fallback contains logic:
Attackers may trigger it unexpectedly.

🚨 Risk 2 – Gas Griefing
Fallback may consume too much gas.

🚨 Risk 3 – delegatecall Storage Collision
If storage layout mismatches between proxy and implementation:
Catastrophic corruption occurs.
Storage slots must align.

🚨 Risk 4 – Reentrancy
Fallback can be triggered during external calls.
Must guard carefully.

Advanced Execution Flow (Proxy)
proxy.store(5)

Flow:
Proxy doesn’t have store()
fallback() triggers
delegatecall to implementation
Implementation executes
State written to Proxy storage

User thinks they called implementation directly.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestFallback {

    event Log(string message);

    receive() external payable {
        emit Log("Receive triggered");
    }

    fallback() external payable {
        emit Log("Fallback triggered");
    }
}

Test:
Send ETH normally → receive triggers
Call non-existent function → fallback triggers
Send ETH + data → fallback triggers

Observe behavior.
*/