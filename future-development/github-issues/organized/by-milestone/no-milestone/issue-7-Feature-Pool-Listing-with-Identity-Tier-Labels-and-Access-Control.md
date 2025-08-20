# Issue #7: Feature Pool Listing with Identity Tier Labels and Access Control

**URL**: https://github.com/hossaryp/beta/issues/7
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/22/2025
**Updated**: 6/22/2025
**Categories**: frontend, backend, security, documentation, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
Currently, users browsing investment pools don’t see identity tier requirements clearly, and can attempt to invest in pools they’re not eligible for. This causes friction, failed flows, and poor onboarding.

🎯 Objective
Show a clear visual tag for each pool’s identity tier (e.g. “OTP Only”, “Tier 1 Required”), and enforce access control based on the user’s current tier. If the user is not eligible, prompt them to upgrade or explore other pools.

🧩 Scope

UI/UX Update

Display identity tier tags on pool cards:

“OTP Only”

“Tier 1 Required”

“Tier 2 Required”

Style tags with neutral design to match brand guidelines

Eligibility Enforcement

When a user clicks “Invest” on a restricted pool:

If their tier is insufficient:

Show message: “Your current tier does not allow investment in this pool”

CTA options:

“Upgrade Your Tier” (if available)

“Explore More Opportunities” (link to Explore tab)

Backend & Metadata

Add minTierRequired field to pool metadata (if not already present)

Compare user tier (from session/auth) with pool / assets requirement

✅ Acceptance Criteria

Identity tier tags appear on every pool card (Pools + Explore tabs)

Users with insufficient tier:

Cannot proceed with investment

Are shown prompt with upgrade or redirect options

Users with valid tier:

Proceed as normal

System enforces logic across all investment entry points

⏳ Priority
HIGH – critical for user guidance, legal compliance, and gated asset access

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

