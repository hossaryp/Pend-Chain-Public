# Issue #26: Feature: Build Settings, Documents, Support, and Logout UI in Profile Tab

**URL**: https://github.com/hossaryp/beta/issues/26
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/24/2025
**Categories**: frontend, security, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
The Pend Beta Profile tab lacks structured navigation for managing account preferences, documents, support, and logout. Without this, users are unable to control their experience, access help, or securely end sessions. These functions are essential for a complete and compliant user profile experience.

🎯 Objective
Create a clean, mobile-first list UI under the profile card that allows users to:

Navigate to profile information

Manage notification preferences

Access legal documents

Contact support

Learn about Pend

Log out safely

Each item should use clear labels, consistent spacing, and optional right arrows to suggest navigation.

🔍 Scope of Work
✅ Section: Settings & Documents
Title (optional): Settings — text-sm, font-semibold, text-black, px-4, mb-2

List Items:

Profile Information → opens modal or screen to edit name, gender, email

Notifications → opens toggle switches for:

Investment Updates

Platform Alerts

Documents 

List Style:

Each row:

Label left-aligned

Optional right arrow (→ icon)

Padding: px-4 py-3

Border-bottom for separation

Font: Poppins, text-sm, text-black

✅ Section: Support
List Items:

Help Center → navigates to FAQ list (e.g. “How do I invest?”)

Contact Support → opens WhatsApp link in new tab or deep link

About Pend → navigates to screen or modal with mission, legal info, version

✅ Section: Logout
Logout Button:

Full-width at the bottom of the Profile tab

Text: Logout

Style: text-red-500, border border-red-200, rounded-lg, py-2 px-4, text-center, font-medium, mt-4, mx-4

Functionality:

Simulate logout by clearing local state

Log to console or redirect to login

✅ Acceptance Criteria
 All list items are styled consistently with proper spacing and font

 Profile Information opens editable modal or screen (can be stub for now)

 Notification toggles work (local state is fine)

 Documents section shows sample files with PDF icon

 Help Center and About Pend open informational views

 Contact Support opens WhatsApp link

 Logout button clears session and logs user out (simulated)

⏳ Priority
MEDIUM-HIGH — Needed for complete profile functionality, but can follow core investment and verification flows



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

