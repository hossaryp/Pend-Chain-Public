# Issue #32: Feature: Backend Endpoint for “Forgot PIN” Flow

**URL**: https://github.com/hossaryp/beta/issues/32
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/29/2025
**Updated**: 7/1/2025
**Categories**: frontend, backend, security
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
 **Objective**
Implement a secure flow to allow users to reset their 6-digit PIN using verified OTP authentication, in compliance with FRA’s digital identity and multi-factor verification rules.

**Acceptance Criteria**
 Create POST /api/pin/reset endpoint
 Request must include:
      1-Verified user ID (or phone number)
      2-Valid OTP (previously issued and matched via possession factor)
      3-New 6-digit PIN
 OTP must be checked against recent issuance (FRA requires Possession Factor for resets)
 New PIN must be validated as numeric and exactly 6 digits
 Hash new PIN securely using bcrypt or argon2
 Overwrite old PIN hash in backend storage
 Return 200 OK on success
 Return appropriate error if:
        1- OTP is invalid or expired
        2-PIN format is incorrect
        3-User does not exist or is not eligible to reset

**FRA Compliance Requirements Applied**
 Reset flow uses OTP as a Possession Factor
 New PIN becomes part of the user’s active multi-factor identity
 Reset event must be securely logged (see below)
 This action is part of digital identity lifecycle, governed by FRA Section Two and Annex 1

 **Security Notes**
 Never log raw or hashed PIN or OTP
 Hash must be generated server-side only
 Reset attempts must be rate-limited to prevent abuse
 Ensure session is not reused across devices after PIN reset

**Identity Ledger Logging (Recommended)**
Log a “PIN_RESET” event to backend’s digital identity ledger:
  1- User ID
  2-Timestamp
  3-OTP verified status
  4-Reset success/failure status

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

