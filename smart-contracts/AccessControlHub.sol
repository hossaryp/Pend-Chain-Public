// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AccessControlHub
 * @dev Central hub for managing all roles system-wide across the PEND ecosystem
 * @notice Provides role-based access control with modifiers and batch operations
 */
contract AccessControlHub {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/
    
    // Role definitions using keccak256 for gas efficiency
    bytes32 public constant ASSET_ISSUER_ROLE = keccak256("ASSET_ISSUER_ROLE");
    bytes32 public constant KYC_CONFIRMER_ROLE = keccak256("KYC_CONFIRMER_ROLE");
    bytes32 public constant CONSENT_AGENT_ROLE = keccak256("CONSENT_AGENT_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");
    bytes32 public constant DATA_VIEWER_ROLE = keccak256("DATA_VIEWER_ROLE");
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    
    // Role management mappings
    mapping(bytes32 => mapping(address => bool)) private _roles;
    mapping(bytes32 => uint256) private _roleCount;
    mapping(address => bytes32[]) private _userRoles;
    mapping(address => mapping(bytes32 => bool)) private _userHasRole;
    
    // Contract metadata
    address public owner;
    bool public paused;
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleBatchGranted(bytes32 indexed role, address[] accounts, address indexed sender);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ContractPaused(address indexed by);
    event ContractUnpaused(address indexed by);
    
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    
    error NotOwner();
    error NotAuthorized();
    error RoleAlreadyGranted();
    error RoleNotGranted();
    error ZeroAddress();
    error ContractIsPaused();
    error InvalidRole();
    error EmptyArray();
    
    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    modifier whenNotPaused() {
        if (paused) revert ContractIsPaused();
        _;
    }
    
    modifier onlyRole(bytes32 role) {
        if (!hasRole(role, msg.sender)) revert NotAuthorized();
        _;
    }
    
    modifier onlyAssetIssuer() {
        if (!hasRole(ASSET_ISSUER_ROLE, msg.sender)) revert NotAuthorized();
        _;
    }
    
    modifier onlyKYCConfirmer() {
        if (!hasRole(KYC_CONFIRMER_ROLE, msg.sender)) revert NotAuthorized();
        _;
    }
    
    modifier onlyConsentAgent() {
        if (!hasRole(CONSENT_AGENT_ROLE, msg.sender)) revert NotAuthorized();
        _;
    }
    
    modifier onlyAuditor() {
        if (!hasRole(AUDITOR_ROLE, msg.sender)) revert NotAuthorized();
        _;
    }
    
    modifier onlyDataViewer() {
        if (!hasRole(DATA_VIEWER_ROLE, msg.sender)) revert NotAuthorized();
        _;
    }
    
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    
    constructor() {
        owner = msg.sender;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    
    /*//////////////////////////////////////////////////////////////
                          ROLE MANAGEMENT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Grant a role to an account
     * @param role The role to grant
     * @param account The account to grant the role to
     */
    function grantRole(bytes32 role, address account) external onlyOwner whenNotPaused {
        _grantRole(role, account);
    }
    
    /**
     * @notice Revoke a role from an account
     * @param role The role to revoke
     * @param account The account to revoke the role from
     */
    function revokeRole(bytes32 role, address account) external onlyOwner whenNotPaused {
        _revokeRole(role, account);
    }
    
    /**
     * @notice Grant a role to multiple accounts in batch
     * @param role The role to grant
     * @param accounts Array of accounts to grant the role to
     */
    function grantRoleBatch(bytes32 role, address[] calldata accounts) external onlyOwner whenNotPaused {
        if (accounts.length == 0) revert EmptyArray();
        
        for (uint256 i = 0; i < accounts.length; i++) {
            _grantRole(role, accounts[i]);
        }
        
        emit RoleBatchGranted(role, accounts, msg.sender);
    }
    
    /**
     * @notice Renounce a role for the calling account
     * @param role The role to renounce
     */
    function renounceRole(bytes32 role) external whenNotPaused {
        _revokeRole(role, msg.sender);
    }
    
    /*//////////////////////////////////////////////////////////////
                         INTERNAL ROLE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function _grantRole(bytes32 role, address account) internal {
        if (account == address(0)) revert ZeroAddress();
        if (_roles[role][account]) revert RoleAlreadyGranted();
        
        _roles[role][account] = true;
        _roleCount[role]++;
        
        // Track user roles for enumeration
        if (!_userHasRole[account][role]) {
            _userRoles[account].push(role);
            _userHasRole[account][role] = true;
        }
        
        emit RoleGranted(role, account, msg.sender);
    }
    
    function _revokeRole(bytes32 role, address account) internal {
        if (!_roles[role][account]) revert RoleNotGranted();
        
        _roles[role][account] = false;
        _roleCount[role]--;
        
        // Update user roles tracking
        _userHasRole[account][role] = false;
        
        // Remove from user roles array
        bytes32[] storage userRoles = _userRoles[account];
        for (uint256 i = 0; i < userRoles.length; i++) {
            if (userRoles[i] == role) {
                userRoles[i] = userRoles[userRoles.length - 1];
                userRoles.pop();
                break;
            }
        }
        
        emit RoleRevoked(role, account, msg.sender);
    }
    
    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Check if an account has a specific role
     * @param role The role to check
     * @param account The account to check
     * @return bool True if the account has the role
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account];
    }
    
    /**
     * @notice Get all roles for a specific account
     * @param account The account to query
     * @return roles Array of role identifiers
     */
    function getRoles(address account) external view returns (bytes32[] memory) {
        return _userRoles[account];
    }
    
    /**
     * @notice Get the number of accounts with a specific role
     * @param role The role to query
     * @return count Number of accounts with the role
     */
    function getRoleMemberCount(bytes32 role) external view returns (uint256) {
        return _roleCount[role];
    }
    
    /**
     * @notice Check multiple roles for an account
     * @param account The account to check
     * @param roles Array of roles to check
     * @return hasRoles Array of booleans indicating role possession
     */
    function hasRoles(address account, bytes32[] calldata roles) external view returns (bool[] memory) {
        bool[] memory results = new bool[](roles.length);
        for (uint256 i = 0; i < roles.length; i++) {
            results[i] = hasRole(roles[i], account);
        }
        return results;
    }
    
    /*//////////////////////////////////////////////////////////////
                          ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Transfer ownership of the contract
     * @param newOwner The new owner address
     */
    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert ZeroAddress();
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
    
    /**
     * @notice Pause the contract
     */
    function pause() external onlyOwner {
        paused = true;
        emit ContractPaused(msg.sender);
    }
    
    /**
     * @notice Unpause the contract
     */
    function unpause() external onlyOwner {
        paused = false;
        emit ContractUnpaused(msg.sender);
    }
    
    /*//////////////////////////////////////////////////////////////
                        ROLE VERIFICATION HELPERS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Check if caller is an asset issuer
     * @return bool True if caller has ASSET_ISSUER_ROLE
     */
    function isAssetIssuer(address account) external view returns (bool) {
        return hasRole(ASSET_ISSUER_ROLE, account);
    }
    
    /**
     * @notice Check if caller is a KYC confirmer
     * @return bool True if caller has KYC_CONFIRMER_ROLE
     */
    function isKYCConfirmer(address account) external view returns (bool) {
        return hasRole(KYC_CONFIRMER_ROLE, account);
    }
    
    /**
     * @notice Check if caller is a consent agent
     * @return bool True if caller has CONSENT_AGENT_ROLE
     */
    function isConsentAgent(address account) external view returns (bool) {
        return hasRole(CONSENT_AGENT_ROLE, account);
    }
    
    /**
     * @notice Check if caller is an auditor
     * @return bool True if caller has AUDITOR_ROLE
     */
    function isAuditor(address account) external view returns (bool) {
        return hasRole(AUDITOR_ROLE, account);
    }
    
    /**
     * @notice Check if caller is a data viewer
     * @return bool True if caller has DATA_VIEWER_ROLE
     */
    function isDataViewer(address account) external view returns (bool) {
        return hasRole(DATA_VIEWER_ROLE, account);
    }
} 