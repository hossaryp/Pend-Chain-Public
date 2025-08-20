# Issue #37: Feature: Calculate Asset Change and Best Performer

**URL**: https://github.com/hossaryp/beta/issues/37
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/30/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend, database, performance
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective
Continuously compute the percentage change in value for each listed asset over time, and identify the top-performing asset based on ROI. This data will support Home page display and internal insights.

Scope
Track Asset Value Over Time

Calculate Percentage Change (Daily / Weekly / Monthly)

Mark Highest Performing Asset

Expose Data via API

Acceptance Criteria
 Store historical price or NAV snapshots for each asset

Daily value log (timestamped)

 Calculate change over time periods:

Daily % change (24h)

Weekly % change (7d)

Monthly % change (30d)

 Store computed change in each asset’s metadata

 Determine the best performing asset based on 7-day ROI

Must be active (not archived or closed)

Update every 24h

 Expose via:

/api/assets/metrics → for each asset: ROI %, trend

/api/home/top-performer → returns best performing asset with change %

Requirements & Validation
Use backend cron or scheduled job to run calculation daily

Exclude assets with missing or stale data (e.g. < 2 records)

Changes must be stored and not recalculated on every request

If no asset has positive performance, return most stable one (lowest volatility)

Optional: Tag top performer in Asset DB model (isTopPerformer: true)

Calculation Logic 
For asset harvest:

Last 7d value = 1150

7d ago = 1000
→ % change = (1150 - 1000) / 1000 × 100 = +15%

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

