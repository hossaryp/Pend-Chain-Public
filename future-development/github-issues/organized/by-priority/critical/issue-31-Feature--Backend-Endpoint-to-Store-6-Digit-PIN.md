# Issue #31: Feature: Backend Endpoint to Store 6-Digit PIN

**URL**: https://github.com/hossaryp/beta/issues/31
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/29/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend, database, security, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective
Create a secure backend endpoint to receive and store a user’s 6-digit PIN after legal agreement acceptance, in compliance with FRA’s requirements for digital identity authentication.

Acceptance Criteria
Create POST /api/pin/set endpoint (accessible only after verified legal consent)
Request must include:
      1- Verified user ID (or verified phone linked to identity)
      2-A 6-digit numeric PIN (Knowledge Factor)
 Validate that PIN is numeric and exactly 6 digits
 Hash the PIN securely using a strong algorithm (e.g. bcrypt or argon2)
 Store the hash in the backend database, associated with the user’s digital identity record
 Return 200 OK on success
 Return appropriate error on failure:
      1- Invalid format
      2-PIN already set (unless part of reset flow)

FRA Compliance Requirements Applied
 PIN is treated as a Knowledge Factor Group element under FRA Section Two
 It must be used with a Possession (e.g. OTP) or Presence (e.g. device) factor for identity verification and gated actions
 PIN setup must occur within a controlled digital identity flow (after legal consent but before full KYC)
 All PIN-related actions must be traceable as part of the Digital Identity Ledger or backend logs

 Security Notes (FRA-Aligned)
 Never log raw or hashed PIN at any point
 All PIN hashing must be performed on the server
 Do not store the PIN in frontend memory or browser storage
 Avoid insecure hashing (MD5, SHA1) — use only approved methods
 Ensure data is retained in a secure digital record, as required under Annex 1 of the FRA decree

🧾 Audit Trail Enhancement
Log PIN setup event in your backend’s Digital Identity Ledger (not the PIN itself)
Timestamp
User ID
Device metadata (if available)

---

## Integration Impact

### Admin Panel Development
⚠️ Consider impact on admin panel features

### Database Migration  
✅ Directly related to database migration

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

