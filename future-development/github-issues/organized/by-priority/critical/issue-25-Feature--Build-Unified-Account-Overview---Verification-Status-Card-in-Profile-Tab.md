# Issue #25: Feature  Build Unified Account Overview & Verification Status Card in Profile Tab

**URL**: https://github.com/hossaryp/beta/issues/25
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/25/2025
**Categories**: frontend, documentation, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
The current profile experience is fragmented — user info and verification status are split across multiple components. This makes it harder for users to understand their identity status, what’s left to complete, and how close they are to being verified. A unified card solves this and gives a clean, guided user experience.

🎯 Objective
Create a single combined card inside the Profile tab that displays:

User ID

“User Since” date

Total Invested

Verification status: 1/5 steps complete

Step label: "Next: Complete Profile Information"

Status tag:

If all steps complete → Verified (orange text + border)

If incomplete → Not Verified (gray border, filled text)

Include a CTA button to “Complete Profile Now”.

🔍 Scope of Work
✅ UI Layout
Card Container:

bg-white, rounded-xl, shadow-sm, px-4 py-4

Margin: mt-4, mb-3, w-full

Top Section (Account Info):

Label: User ID → text-xs, text-gray-500

Value: PND-2024-5847 → text-sm, text-black, font-medium

Label: User Since → same style

Value: e.g. March 2025

Label: Total Invested → same style

Value: e.g. EGP 12,600.00 (formatted with utility)

Divider: optional line or spacing between sections

Bottom Section (Verification Progress):

Text:

Progress: 1 / 5 steps complete

Style: text-sm, text-black

Next Step Label:

Next: Complete Profile Information

text-xs, text-gray-500, margin-top mt-1

Verification Status Tag:

If complete:

Verified

Style: border border-[#FF8A34] text-[#FF8A34] px-3 py-1 text-xs rounded-full

If not complete:

Not Verified

Style: bg-gray-100 text-gray-500 px-3 py-1 text-xs rounded-full

CTA Button:

Label: Complete Profile Now

Full width, solid orange background

Style: bg-[#FF8A34] text-white py-2 px-4 rounded-lg mt-3 text-sm font-medium

✅ Data & Logic
ts
Copy
Edit
const user = {
  userId: "PND-2024-5847",
  createdAt: "2025-03-14",
  totalInvested: 12600,
  stepsCompleted: 1,
  totalSteps: 5
};

const isVerified = user.stepsCompleted === user.totalSteps;
✅ Acceptance Criteria
 Card appears in Profile tab after the header

 Displays user ID, join date, and total investment clearly

 Progress is shown as 1 / 5 steps complete (no % bar)

 If incomplete, status is Not Verified in grey

 If all steps completed, status is Verified in orange

 “Complete Profile Now” CTA triggers next onboarding step (mocked)

 Layout is fully mobile responsive, clean, and branded

⏳ Priority
HIGH — Combines identity, investment, and verification clarity in one critical profile component

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

