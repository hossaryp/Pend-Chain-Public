# Issue #10: Feature Downloadable Legal Documents in Pools

**URL**: https://github.com/hossaryp/beta/issues/10
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/22/2025
**Updated**: 6/22/2025
**Categories**: frontend, backend
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
Currently, users exploring investment pools (e.g. Harvest Fund) have direct, in-app access to legal documents such as SPV registration, redemption terms, or fund structure. 

🎯 Objective
Allow users to access downloadable legal documents (PDFs) directly within each pool’s detail view — clearly labeled, secure, and accessible.

🧩 Scope

UI/UX Update

In the Pool Detail View, add a new section:

Title: Documents

Two categories:

Legal Documents (e.g., SPV registration, fund structure)

Business Documents (e.g., feasibility study, investment overview)

Each document:

Display a PDF icon in Pend orange (#FF8A34)

Clearly labeled (e.g., SPV_Registration.pdf)

Include a download or open link

Backend Integration

Documents should be securely served from the backend

Use a safe, access-controlled download endpoint

✅ Acceptance Criteria

“Documents” section appears in pool detail screen

PDFs are categorized and styled with icons

Clicking opens or downloads the file in-browser

Files must open correctly on both mobile and desktop

⏳ Priority
HIGH – builds user trust, supports due diligence, and ensures regulatory clarity

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

