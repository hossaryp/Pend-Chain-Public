# Issue #15: Profile Screen – Tier Display, Verification Progress, and Personal Info Access

**URL**: https://github.com/hossaryp/beta/issues/15
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/23/2025
**Updated**: 6/30/2025
**Categories**: frontend, database, security, documentation
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
![Image](https://github.com/user-attachments/assets/61b645d0-ddb8-4aa0-9584-706d77902372)

📌 Problem Summary
The current Profile screen shows tier status and basic account info but lacks interactive upgrade logic, tier step clarity, and contextual UX for users navigating their verification journey.

🎯 Objective
Enhance the Profile tab to clearly communicate the user’s current verification tier, show meaningful tier progress, and guide users toward the next action required for upgrade. Optional personal info should remain collapsed unless opened.

🧩 Scope and Required Fixes

Tier Progress Section

🔧 Issue: Current tier is shown but no clarity on completed vs. pending steps.

✅ Fix: Add a multi-step visual progress bar showing all 5 tiers (Mobile → Biometric → KYC → Device → Location).

Current tier in orange (#FF8A34)

Completed steps: gray

Upcoming: light gray

Show tier name under each point (use short labels)

Next Action CTA

🔧 Issue: “Fully Verified” button is inactive even when user has completed Tier 5.

✅ Fix: Make the button dynamic.

If not fully verified → label shows next tier name

If Tier 5 is reached → change label to: Verification Complete and disable

Account Overview

✅ Keep fields: User ID, User Since, Total Invested

Consider adding tier benefits info tooltip (optional)

Add Personal Info

🔧 Issue: Dropdown lacks visibility or prompt

✅ Fix: Add a subtitle or icon next to “Add Personal Info” to prompt user (optional)

✅ Acceptance Criteria

Profile displays user tier and investment details clearly

Progress bar shows all 5 verification steps visually

Upgrade button dynamically guides user to the next verification step

Personal info section is collapsed by default and optional

All labels and UI components follow Pend brand style (white background, Poppins font, orange accent)

⏳ Priority: HIGH
This screen is the central reference for identity and progress — essential for user trust, compliance clarity, and onboarding experience.

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

