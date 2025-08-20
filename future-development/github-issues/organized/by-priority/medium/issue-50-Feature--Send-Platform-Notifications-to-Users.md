# Issue #50: Feature: Send Platform Notifications to Users

**URL**: https://github.com/hossaryp/beta/issues/50
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 7/1/2025
**Updated**: 7/1/2025
**Categories**: frontend, backend, adminPanel, security, testing, devops
**Priority**: medium
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective:
Enable admins to send secure, targeted platform notifications to users regarding approvals, system updates, investment opportunities, or risk disclosures.

User Story:
As an admin, I want to compose and send custom notifications to specific users or all users so I can communicate time-sensitive updates and maintain a compliant communication trail.

Acceptance Criteria:

Notification Form:

Inputs:

Title (max 100 characters)

Message Body (rich text or plain text, 1000 char max)

Target User Selector:

All Users

Specific User(s) by Phone or User ID (multi-select)

On Submit:

Notification is stored in backend message log

Message is pushed to:

In-app frontend inbox (user notification center)

WhatsApp or SMS 

UI Requirements:

Form is accessible only to authorized admin

After submit, a confirmation message is shown


Dependencies:

Backend endpoint: POST /api/admin/notify

User role validation 

Message log system 





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

