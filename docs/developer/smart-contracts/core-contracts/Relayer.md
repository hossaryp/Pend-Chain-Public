# Relayer / API Server

NodeJS Express service found under `server/`.

## Responsibilities
1. Expose REST endpoints for OTP, consent storage, wallet creation and transaction relay.
2. Hold the *validator key* that can operate SmartWallets.
3. Interface with Twilio (or dev console) to send OTP codes.
4. Update identity records via `PendIdentityRegistry.upgradeIdentity` as users complete KYC/biometric checks.

## Environment Variables
| Name | Description |
|------|-------------|
| `RPC_URL` | JSON-RPC endpoint for EVM node |
| `VALIDATOR_PRIVATE_KEY` | Private key with funds and validator role |
| `SMART_WALLET_FACTORY_ADDRESS` | Deployed factory |
| `CONSENT_MANAGER_ADDRESS` | Deployed ConsentManager |
| `TWILIO_*` | Optional – SID, TOKEN, FROM number |
| `IDENTITY_REGISTRY_ADDRESS` | Deployed PendIdentityRegistry |

## Important Routes
| METHOD | Path | Purpose |
|--------|------|---------|
| `POST` | `/api/send-otp` | `{ phone }` – send 6-digit code |
| `POST` | `/api/verify-otp` | `{ phone, code }` – simple dev check, returns `{ success }` |
| `POST` | `/api/store-consent` | `{ phone, otpHash }` – backend commits consent on chain |
| `POST` | `/api/create-wallet` | `{ phoneNumber, otp? }` – deploys wallet (uses consent overload when `otp` provided) |
| `POST` | `/api/execute-transaction` | Relay arbitrary call through SmartWallet |
| `POST` | `/api/upgrade-identity` | `{ user, govIdHash, biometricHash, deviceFingerprint, jurisdiction }` – updates identity record and recomputes consent tier |

## Log System
All major actions are pushed to `server-logs.json` and available via `/api/logs`.

## Development
```
cd server
npm install
npm run start            # loads .env and starts express
```

The hardhat tests spin up an *in-process* chain; for end-to-end manual testing you can run `npx hardhat node` plus the relayer pointing to `localhost:8545`. 