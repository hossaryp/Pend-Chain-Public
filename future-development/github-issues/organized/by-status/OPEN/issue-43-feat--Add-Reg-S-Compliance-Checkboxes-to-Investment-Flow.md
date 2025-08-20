# Issue #43: feat: Add Reg S Compliance Checkboxes to Investment Flow

**URL**: https://github.com/hossaryp/beta/issues/43
**Status**: OPEN
**Author**: hossaryp
**Created**: 6/30/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend, blockchain, testing
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description

Labels: compliance, frontend, blockchain, high-priority

📌 Description
To meet Regulation S requirements, we must ensure that every investor:

Certifies they are not a U.S. person.

Acknowledges they will not hedge or resell in the U.S. unless exempt or registered.

This is mandatory for all investment flows in Pend Beta.

✅ Acceptance Criteria
 Add two checkboxes to InvestmentAgreementModal:

“I certify I am not a U.S. person and am not located in the United States.”

“I agree not to hedge or resell any tokens in the U.S. unless registered or exempt.”

 Disable “Continue” / “Invest” button until both are selected.

 On click, generate a Reg S consent hash and log it via ConsentManager.sol with:

actionId: "reg_s_consent"

User wallet address

Timestamp

(Optional) Geo-location

 Store hash in backend logs for compliance audits.

🧠 Developer Notes
Use existing ConsentManager.logConsent() helper.

Add data-testid="reg-s-checkbox" for each checkbox.

Include Reg S hash in investment payload (optional).

Reuse existing OTP/biometric verification flow if needed.

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

