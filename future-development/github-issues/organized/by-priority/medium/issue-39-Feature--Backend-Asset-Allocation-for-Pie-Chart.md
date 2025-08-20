# Issue #39: Feature: Backend Asset Allocation for Pie Chart

**URL**: https://github.com/hossaryp/beta/issues/39
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/30/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend, performance, testing, devops
**Priority**: medium
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
objective 
Provide clean, structured data showing how a user’s investments are distributed across different assets or categories. This data will be used to generate a visual pie chart on the frontend.

Responsibilities
Aggregate all active investments for a specific user

Calculate:

Total amount invested

Proportional allocation for each asset

Format data to include:

Asset or category name

Absolute amount (e.g. EGP 24,000)

Allocation percentage (e.g. 40%)

Optional: Include category label to group assets (e.g. Real Estate, Agriculture)

Delivery Format
Structured list for each user

Includes one entry per asset (or per category, if grouped)

Percentages must add up to 100%

Round values to 1 decimal place

Must only include active, confirmed investments (exclude pending or redeemed)

Update Frequency
Real-time or pulled upon frontend request

Can be cached briefly if needed (e.g. 5–10 minutes)

Data Integrity Notes
Investments must be validated before inclusion

Percentages are based on invested amounts, not expected returns

Totals should handle edge cases (e.g. 0 investment = empty chart)



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

