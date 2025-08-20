# Issue #38: Feature: Generate Gainers & Losers List (ROI Ranking)

**URL**: https://github.com/hossaryp/beta/issues/38
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/30/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend, adminPanel, database, performance, testing, devops
**Priority**: medium
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective
Provide ranked lists of the best and worst performing assets based on ROI (7-day or 30-day window). This supports analytics dashboards, deeper user insights, and investor trend tracking.

Acceptance Criteria
 Calculate ROI (%) for each asset over 7d and 30d intervals

 Sort assets by ROI descending (gainers) and ascending (losers)

 Store ranked lists in cache (updated every 24h)

 Return top 5 gainers and top 5 losers via API

API Specification
Endpoint: /api/assets/performance

Response:

gainers: [{ id, title, ROI %, category, image }]

losers: [{ id, title, ROI %, category, image }]

Filters (optional):

?period=7d or ?period=30d

Data Rules
Ignore inactive or frozen assets

Exclude assets without enough price history

Rank only assets with valid numeric ROI in the selected period

Avoid duplicates between gainers and losers lists

ROI Calculation Recap
ROI = (Current Value - Value N Days Ago) / Value N Days Ago × 100

Run calculations via backend job or data pipeline

Cache results in Redis or DB for low-latency frontend access

Bonus: Add Gainers & Losers Tags
Optional: add backend logic to label each asset with:

performanceTag: 'gainer' | 'loser' | null

Useful for UI badges or filtering Explore view

---

## Integration Impact

### Admin Panel Development
✅ Directly related to admin panel development

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

