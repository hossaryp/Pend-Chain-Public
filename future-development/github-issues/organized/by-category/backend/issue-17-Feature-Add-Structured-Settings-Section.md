# Issue #17: Feature Add Structured Settings Section

**URL**: https://github.com/hossaryp/beta/issues/17
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/23/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend, adminPanel, security
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
The app currently lacks a centralized Settings section, limiting user control over their experience, preferences, and account-level actions like logout or language change.

🎯 Objective
Design and implement a Settings screen (or section within Profile) that provides users with control over preferences, app behavior, and session management.

🧩 Settings Options to Include

🔐 Account
View Mobile Number (read-only)

Change PIN (optional, if PIN is supported)

🌐 Preferences
Language Selector: Dropdown (e.g. Arabic, English)

Currency Display: Dropdown (EGP / USD)

🔔 Notifications
Toggle: Receive App Alerts (on/off)

Toggle: Investment Updates (on/off)

📱 App Info
Display App Version (static, e.g. v0.62)

About Pend (opens About screen or modal with company/legal info)

Logout button (clears session)

📍 Placement

Accessed from Profile screen via gear icon

🎨 Styling

Mobile-first layout

Poppins font

White background, black text (#000000)

Orange toggles and CTA buttons (#FF8A34)

Use cards or list rows with icons + right arrows

✅ Acceptance Criteria

Each settings group is visible and accessible

Toggles and selectors work (simulate state)

Logout clears session and redirects to login

Language and currency options update state (no backend required yet)

⏳ Priority: MEDIUM
Enables better user control, trust, and flexibility across different regions and use cases.

---

## Integration Impact

### Admin Panel Development
✅ Directly related to admin panel development

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

