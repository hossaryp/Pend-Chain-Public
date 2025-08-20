# Pend Mobile Wallet – End-to-End App Logic

> **Version:** May 2025 – `beta-4`

---

## 📱 Front-End Flow (Client – `wallet-ui`)

```
Welcome ➜ Phone → OTP → Wallet Created → Home
                               │
                               ├── MyPend Tab    (personalized dashboard)
                               ├── Explore Tab   (fractional assets)
                               └── Settings Tab  (export, language, logout)
```

### 1. Onboarding
| Step | Component | Key Actions |
|------|-----------|-------------|
| Welcome | `WelcomeScreen.tsx` | Brand carousel + MetaMask/Phone choice |
| Phone   | `PhoneNumberScreen.tsx` | Collect + validate phone, call `/api/send-otp` |
| OTP     | `OtpVerificationScreen.tsx` | 6-digit input, paste detection, `/api/verify-otp` |
| Wallet  | created via smart-contract factory; address stored in context + `localStorage` |
| Home | `Home.tsx` | KYC-aware profile header integrated into MyPend tab with tier status and upgrade flow |

### 2. Home Tabs
| Tab | Component | Highlights |
|-----|-----------|------------|
| MyPend   | `WalletTab.tsx`   | Personalized dashboard with KYC-aware profile, investment summary, news, top gainers, and referral system |
| Explore  | `ExploreTab.tsx`  | Fractional assets grid (1/2/3/4 cols) + sector pills |
| Settings | `SettingsTab.tsx` | Language, export, support, logout |

### 3. Interaction Patterns
* **BottomNavBar** – fixed, 3 tabs (`home | mypend | explore`). Settings accessible via profile header.
* **EGP Deposit Flow** – Two paths: "Deposit" → EGP selection or "More" → "Add EGP" direct access.
* **Toasts** – success/error feedback via `react-hot-toast`.
* **Responsive Design** – Tailwind break-points (`sm md lg xl`).
* **Emotional Copy** – warm language + emojis; highlight color `#FF8A34`.

---

## 🔗 Smart-Contract Flow (Hardhat + Besu)

1. **ConsentManager.sol** – stores hash(phone, OTP) and tracks verified actions; exposes `getConsentTier` for tiered access.
2. **SmartWalletFactory.sol** – `createWallet(consentHash)` deploys proxy wallet.
3. **SmartWallet.sol** – executes user tx once relayer provides valid consent.
4. **PendIdentityRegistry.sol** – FRA-140 aligned identity (jurisdiction, KYC level).
5. **Tier Logic** – ConsentManager now exposes `getConsentTier`; pools or features can gate access based on the returned tier (0-5).

```
Phone ➜ OTP ➜ ConsentManager.verify ➜ Factory.createWallet ➜ Wallet address
                                    ▲
                                    │
                              Relayer NodeJS
```

*Only the relayer* (validator key) can call restricted functions (`verifyConsent`, `registerKYC`).

---

## 🌐 Backend (Relayer – `server/`)

REST endpoints:
| Route | Purpose |
|-------|---------|
| `POST /send-otp`          | Generate OTP, SMS via Twilio / console in dev |
| `POST /verify-otp`        | Verify code; store consent on chain |
| `POST /register-identity` | Save identity hash to `PendIdentityRegistry` |
| `POST /deposit-egp`       | Mint EGP tokens to user wallet (amount, phone, wallet) |
| `GET  /egp/balance/:address` | Get EGP balance for wallet address |
| `GET  /egp/supply`        | Get total EGP supply |
| `GET  /rwa-opportunities` | Static JSON of real-world assets (RWA) |
| `POST /upgrade-identity` | Update identity with new KYC/biometric data |

Relayer signs txs with `VALIDATOR_PRIVATE_KEY`; RPC URL configurable (e.g. Besu local).

---

## 🚀 Deployment

### Local Chain
```bash
cd hardhat
npm i
yarn hardhat node &          # start
yarn hardhat run scripts/deploy.ts --network localhost
```

### Front-End
```bash
cd wallet-ui
npm i
npm run dev
```

### Backend
```bash
cd server
npm i
SMART_WALLET_FACTORY_ADDRESS=0x… \
CONSENT_MANAGER_ADDRESS=0x… \
IDENTITY_REGISTRY_ADDRESS=0x… \
node index.js
```

---

## 🧑‍🎨 Design Tokens
| Token | Value |
|-------|-------|
| Font  | "Poppins", `sans-serif` |
| Brand orange | `#FF8A34` |
| Radius | `1rem` (`rounded-2xl`) |
| Shadow | Tailwind `shadow-md` |

---

## 📄 License
MIT 