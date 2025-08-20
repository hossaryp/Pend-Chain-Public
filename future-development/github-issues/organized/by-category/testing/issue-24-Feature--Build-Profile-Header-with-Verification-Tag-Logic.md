# Issue #24: Feature: Build Profile Header with Verification Tag Logic

**URL**: https://github.com/hossaryp/beta/issues/24
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/24/2025
**Categories**: frontend, documentation, testing, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
The Pend Beta app currently lacks a structured Profile tab header. Users need to immediately see their account identity and verification status. Without this, the profile experience feels disconnected and unclear, especially for users progressing through tiered verification.

🎯 Objective
Create a top section in the Profile tab that displays:

Circular profile image (placeholder for now)

Masked mobile number

A status tag:

If fully verified → Verified (solid orange border)

If not → Complete Your Profile (orange outline tag)

This component should be mobile-first and styled to Pend guidelines.

🔍 Scope of Work
✅ UI Layout
Container Style:

White background

Padding: px-4 pt-6 pb-4

Use flex flex-col items-center for vertical alignment

Profile Picture:

Circle avatar (w-16 h-16)

rounded-full, border optional

Placeholder image for now (/assets/avatar.svg)

Masked Mobile Number:

Format example: +20XXXXXXXXXX

Font: text-sm, font-medium, text-black

Placed just below the profile image

Status Tag (Dynamic):

If verified:

Text: Verified

Style: px-3 py-1 text-xs border border-[#FF8A34] text-[#FF8A34] rounded-full

If not verified:

Text: Complete Your Profile

Style: px-3 py-1 text-xs border border-dashed border-[#FF8A34] text-[#FF8A34] rounded-full

Margin between elements: gap-2, center aligned

✅ State & Logic
Use a local boolean or status string:

ts
Copy
Edit
const isVerified = true; // or false
const maskedPhone = "+2010XXXXXXXX";
Tag switches conditionally based on isVerified

✅ Acceptance Criteria
 Circular profile image appears at the top of Profile tab

 Mobile number is masked and displayed in readable font

 If verified, a solid orange Verified tag appears

 If incomplete, a dashed orange Complete Your Profile tag appears

 All elements follow spacing, sizing, and branding rules

 No navigation or editing needed at this step

⏳ Priority
HIGH — Required for onboarding flow clarity and identity display


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

