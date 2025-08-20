# Issue #34: Issue: Implement 3-Step Document Upload Flow (Front, Back, Live Photo)

**URL**: https://github.com/hossaryp/beta/issues/34
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/29/2025
**Updated**: 6/30/2025
**Categories**: frontend, backend, security, performance
**Priority**: low
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective
Allow users to upload identity documents in three separate steps — front side, back side, and a live selfie — as part of the KYC flow, in compliance with FRA’s digital identity verification standards.

 Acceptance Criteria
 Create a new screen component: DocumentUploadScreen.tsx

Break the document upload into 3 distinct steps/tabs:
Front Side of ID
  2- Title: "Upload the front of your ID"
  3- Image picker for gallery or camera
  4- Show preview after selection
  5- Require confirmation before proceeding
Back Side of ID
  1- Title: "Upload the back of your ID"
  2- Same image input behavior as above
  3- Preview and proceed control
Live Selfie Photo
  1- Title: "Take a live photo of yourself"
  2- Camera access required (disable gallery)
  3- Require real-time photo capture (no file upload)
  4- Show confirmation before submission
 After the 3rd step, user proceeds to a review and submit screen
 Validate that all three files are present before allowing submission

FRA Compliance (Section: Annex No. 1)
 Front and back ID images = Possession Factor
 Live selfie = Presence Factor
 Selfie must be captured in real-time, not from storage
 Data must be securely handled and not cached in frontend memory after submission
 All uploaded files must be linked to the verified user and submitted via secure endpoint



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

