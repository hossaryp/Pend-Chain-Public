# SmartWalletFactory

Factory contract deploying one SmartWallet per unique identity hash.

## Responsibilities
1. Enforce **one-wallet-per-identity** rule via `walletOfIdentity` mapping.
2. Pass shared `validator` and `consentManager` addresses to every wallet instance.
3. Wallet creation now requires *at minimum* that the identity has verified the `register_phone` action. Other actions (device, biometric, KYC) can be completed later via `PendIdentityRegistry`.

## Constructor Parameters
| Name              | Description                          |
|-------------------|--------------------------------------|
| `_validator`      | Address allowed to operate wallets   |
| `_consentManager` | Deployed ConsentManager instance     |

## Storage
| Variable            | Type     | Description                          |
|---------------------|----------|--------------------------------------|
| `validator`         | address  | Shared validator for all wallets     |
| `consentManager`    | address  | Consent registry address             |
| `walletOfIdentity`  | mapping  | identityHash ⇒ wallet address        |

## Public API
### `createWallet(identityHash)`
Deploys a wallet **without** performing any consent check (assumes `register_phone` was already verified off-chain).

### `createWallet(identityHash, rawInput, phone, action)`
1. Calls `ConsentManager.verifyConsent(rawInput, phone, action)` – typically the `register_phone` action.
2. Reverts if consent fails.
3. Deploys wallet and records mapping.

## Events
`WalletCreated(identityHash, wallet)` 