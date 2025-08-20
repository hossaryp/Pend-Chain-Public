# Issue #3: New Feature: Log and Display Consent-Based Signature Events in UI, API, and Blockchain

**URL**: https://github.com/hossaryp/beta/issues/3
**Status**: CLOSED
**Author**: hossaryp
**Created**: 6/19/2025
**Updated**: 6/22/2025
**Categories**: frontend, backend, blockchain, security
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
New Feature: Log and Display Consent-Based Signature Events in UI, API, and Blockchain

Background
Every sensitive action in Pend (e.g., wallet creation, investment, redemption) currently requires user consent via OTP or biometric. This is validated on-chain through the ConsentManager contract. However, these consents are not yet displayed as signed transactions in the blockchain explorer, wallet activity log, or API responses.

Objective
Introduce a unified "consent signature transaction" for every verified user action (wallet creation, deposit, KYC, etc.), linking it to user identity metadata (e.g., masked phone, biometric, location tier). This enhances auditability, trust, and user transparency.

Scope
1. Consent as a Visible Transaction Type
Each successful consent (e.g., wallet creation, pool deposit) should:
Emit an on-chain ConsentVerified event
Be recorded as a consent_signature transaction type in transaction logs

2. Explorer Update
Show consent transactions in Explorer UI as a new category

Display:

Type (wallet creation, investment, etc.)

Identity (hashed or masked phone)

Consent tier (e.g., biometric, phone OTP, geo-verified)

Timestamp

Example: “Wallet created with biometric + OTP (+20108****, Cairo, Egypt)”

3. Wallet UI Enhancement
In TransactionList.tsx, show:

Consent history (wallet creation, KYC upgrade, pool deposit consent)

Styled tags: ✅ consented, 🔒 biometric, 📍 geo-tagged, 📱 phone

4. API Enhancement

✅ Acceptance Criteria
 On-chain consent logs emitted per action

 Consent transactions shown in Explorer and Wallet UI

 API reflects structured consent_signature type

 Consent actions are categorized and filterable by action type and user tier

⏳ Priority
HIGH — critical for transparency, trust, and audit compliance (FRA, GDPR, Reg S)



---

## Integration Impact

### Admin Panel Development
⚠️ Consider impact on admin panel features

### Database Migration  
⚠️ Consider database implications

### PendScan Enhancement
✅ May impact PendScan modernization

### Mobile App Development
✅ Consider for mobile app API design

## Implementation Checklist
- [ ] Review requirements against future development plans
- [ ] Estimate development effort  
- [ ] Identify dependencies
- [ ] Plan testing strategy
- [ ] Consider integration points
- [ ] Update relevant planning documents

