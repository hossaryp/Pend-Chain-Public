# Issue #40: Feature: Frontend Asset Allocation donut Chart

**URL**: https://github.com/hossaryp/beta/issues/40
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/30/2025
**Updated**: 6/30/2025
**Categories**: frontend, security, documentation, testing, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Purpose
Display a visual donut chart of the user’s investment allocation across real-world assets making it easy to understand their portfolio composition at a glance.

Layout & Behavior
Displayed as a circular donut chart in the My Investments or Profile Summary section

Segments sized according to allocation percentages

Labeling:

Each segment labeled with asset or category name

Show % value inside or on hover

Chart is accompanied by:

A total value (e.g. “Total Investment: EGP 60,000”)

A legend listing each segment with name + % + amount

🎨 Design Guidelines
Font: Poppins

Background: White

Accent: Use Pend orange (#FF8A34) for highlight segments

Legend: Simple list with text color #000000

🧩 UX Notes
Chart updates dynamically based on latest investment data

If investment is zero → show placeholder (“No data to display”)


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

