# Issue #20: Feature: Build Asset Holdings List with Sell Button

**URL**: https://github.com/hossaryp/beta/issues/20
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/24/2025
**Categories**: frontend, database, performance, documentation, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
Users currently cannot view the detailed breakdown of which assets they own in the Your Investments screen. A clear list of asset holdings with value, performance, and an action button is essential for transparency, control, and trust in the platform.

🎯 Objective
Create a scrollable list of horizontal asset cards, each displaying:

Asset name

Thumbnail image

Current value in EGP

ROI % (positive or negative)

"Sell" action button on the right

Cards must follow Pend’s visual standards and support interactive "Sell" behavior (simulated for now).

🔍 Scope of Work
✅ UI Requirements (for each card)
Layout:

Horizontal row

Spacing: gap-3, padding px-4 py-2

Card: bg-white, rounded-xl, shadow-sm, full-width

Left: Thumbnail Image

Size: w-14 h-14 (56x56px)

Shape: rounded-lg

Use local assets or placeholders for:

Olive Trees

Gold Reserve

Date Farm

Center Column:

Name: e.g. “Olive Trees”

Style: text-sm, font-semibold, text-black

Value: e.g. “EGP 7,500”

Style: text-sm, text-black

Return: e.g. “+25%” or “-1.2%”

Style:

If positive: text-[#FF8A34]

If negative: text-gray-500

Right: Sell Button

Text: Sell

Style: text-[#FF8A34], border, border-[#FF8A34], text-xs, rounded-md, px-3 py-1

Button height matches vertical center of card

✅ Asset Data (mock array)
ts
Copy
Edit
[
  {
    id: 1,
    name: "Olive Trees",
    value: "EGP 7,500",
    return: "+25%",
    image: "/assets/olive.png"
  },
  {
    id: 2,
    name: "Gold Reserve",
    value: "EGP 3,600",
    return: "-1.2%",
    image: "/assets/gold.png"
  },
  {
    id: 3,
    name: "Date Farm",
    value: "EGP 1,500",
    return: "+3.7%",
    image: "/assets/date.png"
  }
]
✅ Interaction
Clicking “Sell” should simulate a confirmation handler (e.g. open modal or log to console)

No filters or additional actions at this stage

✅ Acceptance Criteria
 List of 3 assets appears below the Investment Value card

 Each asset card matches spacing, font, and style guide

 ROI color logic applied correctly (orange if +, gray if –)

 Sell button is clickable and styled with orange outline

 Layout is fully mobile-responsive with consistent spacing

 Cards use local image assets (placeholder okay)

⏳ Priority
HIGH — Essential for user transparency and interaction with their holdings

![Image](https://github.com/user-attachments/assets/a7a2ddb3-a27a-4b04-9f6a-80ce23bd9d4a)

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

