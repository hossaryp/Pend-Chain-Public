// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IAccessControlHub
 * @dev Interface for the AccessControlHub contract
 * @notice Allows other contracts to integrate with the centralized role management system
 */
interface IAccessControlHub {
    // Role constants
    function ASSET_ISSUER_ROLE() external view returns (bytes32);
    function KYC_CONFIRMER_ROLE() external view returns (bytes32);
    function CONSENT_AGENT_ROLE() external view returns (bytes32);
    function AUDITOR_ROLE() external view returns (bytes32);
    function DATA_VIEWER_ROLE() external view returns (bytes32);
    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
    
    // Role checking functions
    function hasRole(bytes32 role, address account) external view returns (bool);
    function getRoles(address account) external view returns (bytes32[] memory);
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
    function hasRoles(address account, bytes32[] calldata roles) external view returns (bool[] memory);
    
    // Convenience role checkers
    function isAssetIssuer(address account) external view returns (bool);
    function isKYCConfirmer(address account) external view returns (bool);
    function isConsentAgent(address account) external view returns (bool);
    function isAuditor(address account) external view returns (bool);
    function isDataViewer(address account) external view returns (bool);
    
    // Events
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleBatchGranted(bytes32 indexed role, address[] accounts, address indexed sender);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ContractPaused(address indexed by);
    event ContractUnpaused(address indexed by);
} 