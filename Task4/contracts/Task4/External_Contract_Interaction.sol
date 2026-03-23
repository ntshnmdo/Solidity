// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// ERC20 Interface
interface IERC20 {
    function balanceOf(address user) external view returns (uint256);
}

contract TokenChecker {

    function checkTokenBalance(address token, address user)
        public
        view
        returns (uint256)
    {
        // Create interface instance pointing to token contract
        IERC20 erc20 = IERC20(token);

        // Call external contract
        return erc20.balanceOf(user);
    }
}