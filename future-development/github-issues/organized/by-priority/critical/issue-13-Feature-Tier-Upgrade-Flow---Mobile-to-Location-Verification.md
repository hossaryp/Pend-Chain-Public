# Issue #13: Feature Tier Upgrade Flow – Mobile to Location Verification

**URL**: https://github.com/hossaryp/beta/issues/13
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/23/2025
**Updated**: 6/30/2025
**Categories**: frontend, security, testing, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
Current tier progression lacks a clear structure and does not enforce sequential identity verification. A consistent upgrade flow with proper UI and action requirements is needed to improve compliance, security, and UX.

🎯 Objective
Implement a modal-based, sequential Tier Upgrade Flow starting from mobile verification and ending with location access. Each tier should unlock only after the previous one is completed, with actions based on device capabilities.

🧩 Tier Structure & Required Actions

Tier 1 – Mobile Verification

Action: Enter mobile number + receive OTP

Result: Create wallet and link identity hash

✅ Current tier for most users

Tier 2 – Biometric Verification

Action: Prompt to enable Face ID or fingerprint authentication

Result: Bind biometric trust layer to user account

Purpose: Add security for device-based login and account recovery

Tier 3 – KYC Verification

Action: Upload national ID (front + back)

Result: Full user KYC for regulated pools and large investments

Tier 4 – Device Verification

Action: Toggle to allow device identity binding (e.g. device ID or secure element)

Purpose: Prevent fraud, restrict access to trusted devices

Tier 5 – Location Verification

Action: Toggle to allow GPS or telecom location access

Result: Unlock geo-specific pools based on user location

Purpose: Enforce regional regulations

✅ Acceptance Criteria

Progress bar clearly displays current and locked tiers

"Upgrade Tier" button opens modal with only next required step

Modals use device capabilities where possible (biometric, GPS, etc.)

File inputs for ID upload where needed

Cannot skip or jump tiers

After each step, user tier is updated in UI and stored (simulate with state)

⏳ Priority: HIGH
Essential for compliant onboarding, fraud prevention, and feature access control.



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

