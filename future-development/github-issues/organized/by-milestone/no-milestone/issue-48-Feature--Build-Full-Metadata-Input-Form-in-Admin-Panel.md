# Issue #48: Feature: Build Full Metadata Input Form in Admin Panel

**URL**: https://github.com/hossaryp/beta/issues/48
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 7/1/2025
**Updated**: 7/1/2025
**Categories**: frontend, backend, blockchain, adminPanel, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective:
Enable admins to input full asset metadata including legal documents and upload media directly from the Admin Panel.

User Story:
As an admin, I want to enter detailed asset information (including ROI, documents, and asset manager) and upload media files so each listed opportunity is clear, compliant, and professional.

Acceptance Criteria:
Update the Create Asset form to include:

All text fields:

Asset Name

Sector (dropdown)

Location

Description

Lock Period

ROI (text or range)

ROI Model (dropdown)

Min Investment

Asset Manager

Highlights

Upload fields:

Thumbnail (JPG/PNG → backend returns thumbnailId)

Legal Document (PDF → returns legalDocURL)

Business Document (PDF → returns businessDocURL)

Invetsment Agreement 

On submission:

POST metadata + URLs/IDs to backend

Backend calls AssetFactory.createAsset() with all fields

Dependencies:

Smart contract support for full metadata 

Backend endpoints for:

Uploading image → returns thumbnailId

Uploading PDFs → returns legalDocURL and businessDocURL and invetsment agreemnetDocURL

FRA Compliance:

Public Offering Information

ROI & Lock Period Transparency

Document Traceability



---

## Integration Impact

### Admin Panel Development
✅ Directly related to admin panel development

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

