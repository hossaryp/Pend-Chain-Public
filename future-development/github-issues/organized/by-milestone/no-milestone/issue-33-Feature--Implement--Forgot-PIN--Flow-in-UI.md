# Issue #33: Feature: Implement “Forgot PIN” Flow in UI

**URL**: https://github.com/hossaryp/beta/issues/33
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/29/2025
**Updated**: 7/1/2025
**Categories**: frontend, backend, database, security
**Priority**: medium
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective
Allow users to securely reset their 6-digit PIN through the app interface by verifying their identity using OTP (Possession Factor), in accordance with FRA’s identity authentication rules.

Acceptance Criteria
 Add a “Forgot PIN?” link to the PIN entry modal or lock screen
 On tap, redirect user to ForgotPinScreen
 Forgot PIN flow must include the following steps:
      1-Display user’s masked phone number
      2-Tap “Send OTP” → Call existing OTP API
      3-Show OTP input field
      4-lidate OTP → Show new PIN form
      5-Enter + confirm 6-digit PIN (masked)
      6-Submit → Call POST /api/pin/reset
      7-On success → Redirect to unlocked state (Explore or Home)
 PIN fields must:
    1-Accept only 6 numeric digits
    2-Mask input (••••••)
    3-Show error if PINs don’t match
 Show error states for:
   1-OTP invalid or expired
   2-PIN format incorrect
   3-General failure from backend
 Include loading states, success feedback, and clear UI steps

FRA Compliance (Frontend Role)
 OTP = Possession Factor, mandatory before allowing PIN reset
 PIN = Knowledge Factor, must follow 6-digit masked UI standard
 User identity must already be established (logged-in session with verified phone)
 No PIN value may be stored in memory, localStorage, or passed unmasked in requests

UI Components Involved
 EnterPinModal.tsx → Add “Forgot PIN?”
 ForgotPinScreen.tsx → OTP input and PIN reset UI
 PinForm.tsx → Reusable masked 6-digit PIN input
 OtpInput.tsx → Reuse existing OTP input with 6-digit support
 Success message → “Your PIN has been reset successfully”

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

