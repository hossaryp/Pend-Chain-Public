// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SmartWallet.sol";
import "./IConsentManager.sol";

/**
 * @title SmartWalletFactory
 * @dev Deploys one SmartWallet per unique owner identity and keeps track of
 *      the resulting wallet addresses.  All wallets are configured with the
 *      same trusted `validator` address supplied at construction.
 */
contract SmartWalletFactory {
    /// -----------------------------------------------------------------------
    /// Storage
    /// -----------------------------------------------------------------------

    /// @notice Trusted validator / relayer address shared by all wallets
    address public immutable validator;

    /// @notice Consent manager address
    address public immutable consentManager;

    /// @notice Mapping from identity hash to the deployed wallet address
    mapping(bytes32 => address) public walletOfIdentity;

    /// -----------------------------------------------------------------------
    /// Events
    /// -----------------------------------------------------------------------

    /**
     * @notice Emitted when a new SmartWallet is deployed for an identity.
     * @param ownerIdentityHash  Identity hash representing the wallet owner
     * @param wallet             Address of the newly deployed wallet
     */
    event WalletCreated(bytes32 indexed ownerIdentityHash, address indexed wallet);

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------

    /**
     * @param _validator  Address of the trusted validator / relayer
     * @param _consentManager  Address of the consent manager
     */
    constructor(address _validator, address _consentManager) {
        require(_validator != address(0), "SmartWalletFactory: validator is zero address");
        require(_consentManager != address(0), "SmartWalletFactory: consentManager is zero address");
        validator = _validator;
        consentManager = _consentManager;
    }

    /// -----------------------------------------------------------------------
    /// External Functions
    /// -----------------------------------------------------------------------

    /**
     * @notice Deploys a new SmartWallet for `ownerIdentityHash`.
     * @dev Reverts if a wallet for the given identity already exists.
     * @param ownerIdentityHash Identity hash that will own the wallet
     * @return wallet Address of the newly created SmartWallet
     */
    function createWallet(bytes32 ownerIdentityHash) external returns (address wallet) {
        require(walletOfIdentity[ownerIdentityHash] == address(0), "SmartWalletFactory: wallet already exists");
        wallet = address(new SmartWallet(ownerIdentityHash, validator, consentManager));
        walletOfIdentity[ownerIdentityHash] = wallet;
        emit WalletCreated(ownerIdentityHash, wallet);
    }

    /**
     * @notice Deploys a new SmartWallet for `ownerIdentityHash` with consent verification.
     * @dev Reverts if a wallet for the given identity already exists.
     * @param ownerIdentityHash Identity hash that will own the wallet
     * @param rawInput Raw input data for consent verification
     * @param phoneNumber Phone number for consent verification
     * @param action Action for consent verification
     * @return wallet Address of the newly created SmartWallet
     */
    function createWallet(
        bytes32 ownerIdentityHash,
        bytes calldata rawInput,
        string calldata phoneNumber,
        string calldata action
    ) external returns (address wallet) {
        require(walletOfIdentity[ownerIdentityHash] == address(0), "SmartWalletFactory: wallet already exists");
        bool ok = IConsentManager(consentManager).verifyConsent(rawInput, phoneNumber, action);
        require(ok, "SmartWalletFactory: consent verification failed");
        wallet = address(new SmartWallet(ownerIdentityHash, validator, consentManager));
        walletOfIdentity[ownerIdentityHash] = wallet;
        emit WalletCreated(ownerIdentityHash, wallet);
    }
} 