# Issue #41: Feature: Backend generate Recent Activity Feed

**URL**: https://github.com/hossaryp/beta/issues/41
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/30/2025
**Updated**: 6/30/2025
**Categories**: backend, security, testing, devops
**Priority**: medium
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
objective 
Provide a structured feed of all recent user investment actions (e.g. deposits, asset purchases, redemptions) for display in the app. Data must be sourced from logged consent-based transactions or signed actions.

Acceptance Criteria
 Return a user’s most recent 10–20 investment actions in chronological order

 Each item includes:

Type: investment, deposit, redemption

Asset name

Amount (in EGP)

Timestamp

 Only include confirmed actions with successful status

 Pull data from:

ConsentManager logs (on-chain)

Backend transaction records (verified events)

API Specification
Endpoint: /api/user/:id/activity-feed

Returns (sample):

"You invested EGP 10,000 in Farmland Egypt on June 20"

"You redeemed EGP 5,000 from Olive Basket on June 17"

Rules
Ensure user identity is authenticated before fetching

Do not include pending, failed, or test transactions

Consent or signature hash should be internally linked to each action for traceability

---

## Integration Impact

### Admin Panel Development
⚠️ Consider impact on admin panel features

### Database Migration  
⚠️ Consider database implications

### PendScan Enhancement
⚠️ Review for PendScan relevance

### Mobile App Development
✅ Consider for mobile app API design

## Implementation Checklist
- [ ] Review requirements against future development plans
- [ ] Estimate development effort  
- [ ] Identify dependencies
- [ ] Plan testing strategy
- [ ] Consider integration points
- [ ] Update relevant planning documents

