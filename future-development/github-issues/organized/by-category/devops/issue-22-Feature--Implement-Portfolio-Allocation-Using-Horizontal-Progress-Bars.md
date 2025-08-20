# Issue #22: Feature: Implement Portfolio Allocation Using Horizontal Progress Bars

**URL**: https://github.com/hossaryp/beta/issues/22
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/24/2025
**Categories**: frontend, database, security, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
Pend Beta users need a simple visual that shows how their portfolio is divided across different assets. A circular chart may not be optimal for mobile screens. A clean, stacked horizontal progress bar offers a more compact, readable alternative while keeping the design lightweight.

🎯 Objective
create a horizontal stacked progress bar that visually represents the user’s portfolio allocation by asset. Each segment corresponds to an asset and its share in the total investment amount.

🔍 Scope of Work
✅ UI Layout
Section Title:

Text: "Portfolio Allocation"

Style: text-sm, font-semibold, text-black, margin-bottom mb-2

Progress Bar Container:

w-full, h-4, rounded-full, overflow-hidden

bg-[#F3F4F6] as background bar

Inner Segments:

Rendered as divs with:

flex-grow based on percentage

Inline style={{ width: "60%" }} etc.

Distinct background color per asset (assigned from config)

No borders

Legend Below Bar:

Row of:

Small colored dot

Asset name

Percentage (e.g. “Olive Trees – 60%”)

Spacing: mt-3, gap-3, px-4

✅ Example Asset Allocation Data
ts
Copy
Edit
const allocation = [
  { name: "Olive Trees", percent: 60, color: "#FF8A34" },
  { name: "Gold Reserve", percent: 28, color: "#D1D5DB" },
  { name: "Date Farm", percent: 12, color: "#E5E7EB" }
];
✅ Functional Notes
Use a component called <PortfolioProgressBar />

Accepts props: data: Allocation[]

Uses map() to render dynamic widths

No animation required

Text does not overlap with the bar

✅ Acceptance Criteria
 Portfolio Allocation section is titled and styled properly

 Horizontal bar reflects asset split by percentage

 Segments accurately sized by percent

 Color legend below the bar with asset names and share

 Fully responsive on all screen sizes

 Aligned with Pend brand design and typography

⏳ Priority
MEDIUM-HIGH — Important for investment clarity, but follows core value and asset interaction features

![Image](https://github.com/user-attachments/assets/5cb20645-a5f4-46f8-80d4-2f11ff5b1138)



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

