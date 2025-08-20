# Issue #14: Feature Add Profile Card to Top of Hub Screen

**URL**: https://github.com/hossaryp/beta/issues/14
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/23/2025
**Updated**: 6/30/2025
**Categories**: frontend, security, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
The Hub screen currently lacks quick access to the user’s profile identity and verification tier. This makes it harder for users to know their current status and navigate to their full profile.

🎯 Objective
Add a Profile Card component at the top of the Hub screen to display key user identity info (ID, username, tier) and allow quick access to the full Profile view.

🧩 Card Requirements

1. Display Fields:

User ID (e.g., PND-2024-5847) or (e.g., User–04421)

Tier Badge (e.g., Tier 1) with orange styling (#FF8A34)

profile icon placeholder

2. Interaction:

Entire card is clickable

Navigates to full Profile screen

3. Styling:

Card with soft shadow and rounded corners

White background (#FFFFFF)

Use Poppins font

Maintain spacing consistency with rest of Hub components

4. Placement:

Insert above the first section in the Hub screen layout

✅ Acceptance Criteria

Profile Card is visible at the top of the Hub

Shows User ID, Tier, and Username properly

Clicking the card takes user to Profile screen

Style fully matches Pend visual system

⏳ Priority: HIGH
It’s the first interaction point for the user inside the app and sets the tone for identity-aware navigation.

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

