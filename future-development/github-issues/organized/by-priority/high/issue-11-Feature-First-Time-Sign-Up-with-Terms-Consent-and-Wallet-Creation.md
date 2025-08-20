# Issue #11: Feature First-Time Sign-Up with Terms Consent and Wallet Creation

**URL**: https://github.com/hossaryp/beta/issues/11
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/22/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
New users must not proceed with onboarding or wallet creation without legally accepting Pend’s Terms and Agreement. Currently, there's no enforced pre-consent step before OTP. This poses a compliance risk and lacks a clear audit trail.

🎯 Objective
Introduce a mandatory terms acceptance step before sending the OTP, and trigger identity + wallet creation only after successful OTP verification.

🧩 Scope

UI/UX Update

On entering a mobile number:

Show Terms and Agreement checkbox:

Label: “I agree to Pend’s Terms and Conditions”

Link to full document (modal or external)

Disable OTP submission unless checkbox is checked

OTP Verification Logic

After checkbox is accepted and OTP is successfully entered:

Generate a unique identity hash

Create a wallet linked to that identity

Store:

mobileNumber

identityHash

walletAddress

System Constraints

Only one identity per mobile number

Identity hash stored on backend, not on-chain

✅ Acceptance Criteria

Users cannot receive OTP unless they accept terms

OTP is only sent after consent

Wallet + identity are created only after valid OTP

Consent is logged for legal tracking

Repeat logins skip this step

⏳ Priority
HIGH – Required for legal compliance, wallet issuance, and onboarding integrity



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

