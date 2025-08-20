# Issue #19: Feature  Create "Your portfolio " Summary Card

**URL**: https://github.com/hossaryp/beta/issues/19
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/30/2025
**Categories**: frontend, database, documentation, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
Users currently have no way to hide their total investment value from others around them. In public or shared environments, privacy is important. The investment summary card should include an option to toggle between showing and hiding the EGP amount and return.

🎯 Objective
Build a summary card that displays the user's total investment value, return, and last updated timestamp. Add an eye icon that lets the user toggle visibility of their investment amounts. Default state is visible.

🔍 Scope of Work
✅ UI Requirements
Card Title Row:

Text: "Your Investment Value"

Right-aligned eye icon (eye / eye-off, from lucide-react or similar)

Icon clickable to toggle value visibility

Card Content (Visible State):

Value: EGP 12,600.00

text-2xl, font-bold, text-black

Return: +EGP 1,250

text-sm, text-[#FF8A34]

Timestamp: Last Updated: Jun 23, 2025

text-xs, text-gray-500

Card Content (Hidden State):

Value: •••••••••

Return: hidden or —

Timestamp still visible

Card Style:

Background: bg-[#FFF8F4]

Padding: px-4 py-3

Border radius: rounded-xl

Shadow: shadow-sm

✅ State & Behavior
React useState to manage isVisible toggle

Default: true

On icon click:

Toggle isVisible

Change icon accordingly (eye ↔ eye-off)

✅ Acceptance Criteria
 Card appears on top of the Your Investments screen

 Eye icon is aligned right in the title row

 Clicking eye toggles visibility of value and return

 Hidden state shows dots (•••••••••) for value

 Timestamp remains visible in both states

 Fully responsive and styled according to Pend guidelines

 No use of emojis, green/red, or off-brand colors

⏳ Priority
HIGH — Required for user privacy and mobile usability in public spaces

![Image](https://github.com/user-attachments/assets/f31edc7a-c04e-4925-8fe1-db7cc5f3040f)



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

