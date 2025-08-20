# Issue #5: Feature: Show Investment Agreement Before Consent for Pool Investment

**URL**: https://github.com/hossaryp/beta/issues/5
**Status**: CLOSED
**Author**: hossaryp
**Created**: 6/19/2025
**Updated**: 6/22/2025
**Categories**: frontend, testing, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Problem Summary
Currently, when a user clicks "Invest" in a pool (e.g., Harvest Pool), they are immediately prompted for consent (OTP or biometric). However, there is no prior step to review or approve the legal agreement (terms of investment, SPV ownership, redemption policy, etc.).

 Objective
Introduce a pre-consent agreement approval step in the investment flow. Users must review and accept a pool-specific contract/terms before proceeding to the consent phase.

🧩 Scope
1. UI/UX Update
On "Invest" click:

Display modal or screen titled:
“Investment Agreement – Powered by Dpend for Agri Investments”

Include:

Summary of the agreement (editable in CMS or markdown file)

Link to full legal PDF (optional)

Checkbox: “I agree to the terms and conditions”

Only after checkbox is selected, the "Continue" button activates

2. Consent Triggering
Once user agrees to the terms:

Then trigger the existing consent step (OTP, biometric)

Store both:

agreementAccepted: true

consentHash for the action (e.g., harvest_invest)

3. Audit Logging
Log both agreement acceptance and consent in transaction log:


✅ Acceptance Criteria
 Agreement modal shown before consent

 Checkbox must be ticked before continuing

 Consent action only triggered after agreement is accepted

 Agreement acceptance is logged as a separate transaction event

 No user can bypass agreement screen before investing

⏳ Priority
HIGH – critical for legal compliance, user clarity, and regulatory audit trail (especially under FRA and Reg S jurisdictions)



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

