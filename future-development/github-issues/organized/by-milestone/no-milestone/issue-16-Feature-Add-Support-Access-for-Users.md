# Issue #16: Feature Add Support Access for Users

**URL**: https://github.com/hossaryp/beta/issues/16
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/23/2025
**Updated**: 6/23/2025
**Categories**: frontend, backend, security, documentation, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
Users currently don’t have a visible way to get help or report problems. This creates friction during critical flows like deposits and tier upgrades.

🎯 Objective
Create a Support section that gives users instant help through WhatsApp chat, allows them to report problems, and optionally provides FAQ content for common questions.

🧩 Support Options to Include
📘 Help Topics / FAQ (at first)
Static answers to common questions:

How do I deposit?

How do I upgrade my tier?

Why is my deposit pending?

💬 Chat with Support
Button label: Chat with Support

Opens: WhatsApp chat link to Pend’s official support line

Subtitle: “Need help? Talk to our team instantly”

📎 Report a Problem
Button label: Report a Problem

Opens a simple form with:

Dropdown: Select issue type (Deposit, Tier, Access, Other)

Text field: Let the user describe the problem

Submit: Orange button (#FF8A34) — simulate send


📍 Placement

include it in the Settings screen under a new "Support" category

🎨 Styling Guidelines

White background

Text color: #000000

CTA buttons and active elements: #FF8A34

Font: Poppins

Mobile-first, clean layout

✅ Acceptance Criteria

Support section is clearly visible and accessible

WhatsApp button opens correctly

Issue report form functions visually (no backend needed yet)

Help Topics shown as plain text (optional, if included)

No email support shown anywhere in UI

⏳ Priority: HIGH
Essential for reducing friction, increasing trust, and resolving user confusion in key flows like identity and deposits.

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

