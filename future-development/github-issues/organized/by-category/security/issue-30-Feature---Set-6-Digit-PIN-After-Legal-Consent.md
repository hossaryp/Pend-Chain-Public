# Issue #30: Feature:  Set 6-Digit PIN After Legal Consent

**URL**: https://github.com/hossaryp/beta/issues/30
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/29/2025
**Updated**: 6/30/2025
**Categories**: backend, security, devops
**Priority**: medium
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
As a user, I want to:
Create and confirm a 6-digit PIN right after accepting legal terms, so I can secure my session and protect access to sensitive actions in the app.

Acceptance Criteria
After legal terms are accepted, the user is directed to the Set PIN screen
The screen displays:
Title: “Create your 6-digit PIN”
Subtext: “This PIN will protect your wallet and investments”
 
User must:
Enter a 6-digit numeric PIN (masked input)
Confirm the same 6-digit PIN
Tap “Confirm” to continue
 PIN mismatch triggers error: "PINs do not match"

 On confirmation:
PIN is hashed using bcrypt or argon2
Hash is sent to POST /api/pin/set
Server stores it securely, associated with user ID / phone
User is then forwarded to KYC flow or Home Tab 

---

## Integration Impact

### Admin Panel Development
⚠️ Consider impact on admin panel features

### Database Migration  
⚠️ Consider database implications

### PendScan Enhancement
⚠️ Review for PendScan relevance

### Mobile App Development
✅ Consider for mobile app API design

## Implementation Checklist
- [ ] Review requirements against future development plans
- [ ] Estimate development effort  
- [ ] Identify dependencies
- [ ] Plan testing strategy
- [ ] Consider integration points
- [ ] Update relevant planning documents

