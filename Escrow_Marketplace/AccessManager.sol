// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AccessManager {

    // Roles: bytes32 are gas-efficient and standard
    // keccak256: Unique role IDs and Industry standard (used in OpenZeppelin)
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
    bytes32 public constant SELLER_ROLE = keccak256("SELLER");
    bytes32 public constant MEDIATOR_ROLE = keccak256("MEDIATOR");

    // Role storage: roles[user][role] = true/ false
    mapping(address => mapping(bytes32 => bool)) private roles;

    // Custom errors: Gas Efficient
    error Unauthorized();

    // Events
    event RoleGranted(bytes32 indexed role, address indexed account);
    event RoleRevoked(bytes32 indexed role, address indexed account);

    // Constructor: deployer becomes Admin
    constructor() {
        roles[msg.sender][ADMIN_ROLE] = true;
    }

    // Modifier
    modifier onlyRole(bytes32 role) {
        if (!roles[msg.sender][role]) revert Unauthorized();
        _;
    }

    // Grant role
    function grantRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        roles[account][role] = true;
        emit RoleGranted(role, account);
    }

    // Revoke role
    function revokeRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        roles[account][role] = false;
        emit RoleRevoked(role, account);
    }

    // Check role: View Function
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return roles[account][role];
    }
}