# Issue #49: Feature: Display Full Asset Metadata in Explore Tab and Detail View  for investors

**URL**: https://github.com/hossaryp/beta/issues/49
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 7/1/2025
**Updated**: 7/1/2025
**Categories**: backend, adminPanel, documentation, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective:
Display all asset metadata in the Explore tab card and asset detail view using values stored on-chain and media served from the backend.

 User Story:
As a user, I want to see all relevant information (ROI, lock period, docs, etc.) about each asset so I can invest with confidence and clarity.

Acceptance Criteria:

Explore Tab Card:

Show:

Asset name

Thumbnail image (from backend using thumbnailId)

Sector, Location

Expected ROI

Lock Period

Minimum Investment

Asset Manager

Progress %, Investors, Raised Amount

Asset Detail View:

Show all fields from metadata:

Description

ROI Model

Highlights

Impact Statement

Download buttons for:

Legal Document (legalDocURL)

Business Document (businessDocURL)

Investment Agreement

🔗 Dependencies:

Contract metadata via getAsset(id) 

Admin entry with complete metadata 

Backend image and file serving endpoints

FRA Compliance:

Transparent Asset Presentation

Legal & Business Document Access

Clarity on ROI, Risk, and Asset Manager



---

## Integration Impact

### Admin Panel Development
✅ Directly related to admin panel development

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

