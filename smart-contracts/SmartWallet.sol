// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IConsentManager.sol";

/**
 * @title SmartWallet
 * @dev Wallet controlled solely by a trusted validator/relayer bound to an identity hash.
 */
contract SmartWallet {
    /// -----------------------------------------------------------------------
    /// Storage
    /// -----------------------------------------------------------------------

    /// @notice Identity hash that represents the logical owner of this wallet
    bytes32 public immutable ownerIdentityHash;

    /// @notice Trusted validator / relayer allowed to operate the wallet
    address public immutable validator;

    /// @notice Consent manager address
    address public immutable consentManager;

    /// -----------------------------------------------------------------------
    /// Events
    /// -----------------------------------------------------------------------

    /**
     * @notice Emitted every time the validator executes a call on behalf of the
     *         identity.
     * @param ownerIdentityHash  Identity hash that authorised the action
     * @param actionHash         Action hash that authorised the action
     * @param target             Destination contract of the call
     * @param data               Calldata used for the call
     * @param result             Raw returned data from the call
     */
    event ExecutedByIdentity(
        bytes32 indexed ownerIdentityHash,
        bytes32 indexed actionHash,
        address indexed target,
        bytes data,
        bytes result
    );

    /// -----------------------------------------------------------------------
    /// Modifiers
    /// -----------------------------------------------------------------------

    /**
     * @dev Restricts function execution to the configured validator address.
     */
    modifier onlyValidator() {
        require(msg.sender == validator, "SmartWallet: caller is not validator");
        _;
    }

    modifier consentRequired(string memory action) {
        require(IConsentManager(consentManager).isVerified(ownerIdentityHash, action), "SmartWallet: consent missing");
        _;
    }

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------

    /**
     * @param _ownerIdentityHash  Hash that uniquely identifies the wallet owner
     * @param _validator          Trusted validator / relayer address
     * @param _consentManager     Consent manager address
     */
    constructor(bytes32 _ownerIdentityHash, address _validator, address _consentManager) {
        require(_validator != address(0), "SmartWallet: validator is zero address");
        require(_consentManager != address(0), "SmartWallet: consentManager is zero address");
        ownerIdentityHash = _ownerIdentityHash;
        validator = _validator;
        consentManager = _consentManager;
    }

    /// -----------------------------------------------------------------------
    /// External Functions
    /// -----------------------------------------------------------------------

    /**
     * @notice Perform an arbitrary call on behalf of the identity.
     * @dev Can only be invoked by the validator.  Additional permission logic
     *      can be introduced by extending this function (e.g. recording allowed
     *      selectors per identity, signature verification, etc.).
     * @param identityHash  Identity hash supplied by the validator.  Must match
     *                      the stored `ownerIdentityHash`.
     * @param action        Action string supplied by the validator.  Must match
     *                      the stored action for the identity.
     * @param target        Destination contract for the call
     * @param data          Calldata for the call
     * @return result       Raw returned data
     */
    function executeTransaction(
        bytes32 identityHash,
        string calldata action,
        address target,
        bytes calldata data
    ) external onlyValidator returns (bytes memory) {
        require(identityHash == ownerIdentityHash, "SmartWallet: identity mismatch");
        require(target != address(0), "SmartWallet: target is zero address");
        require(IConsentManager(consentManager).isVerified(identityHash, action), "SmartWallet: consent not verified");

        (bool success, bytes memory result) = target.call(data);
        require(success, "SmartWallet: call failed");

        emit ExecutedByIdentity(identityHash, keccak256(abi.encodePacked(action)), target, data, result);
        return result;
    }

    /// -----------------------------------------------------------------------
    /// Receive Ether
    /// -----------------------------------------------------------------------

    /// @notice Allow wallet to receive ETH.
    receive() external payable {}
} 