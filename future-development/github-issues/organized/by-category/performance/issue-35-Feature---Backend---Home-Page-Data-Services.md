# Issue #35: Feature:  Backend — Home Page Data Services

**URL**: https://github.com/hossaryp/beta/issues/35
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/29/2025
**Updated**: 6/29/2025
**Categories**: backend, adminPanel, performance
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Objective
Provide reliable, up-to-date content to populate the home screen with structured investment data, curated banners, sector listings, and educational material. Ensure content is cacheable, dynamic, and manageable.

Data Endpoints
1. Banners
Endpoint: /api/home/banners
Returns: Array of banner objects with:
Image URL
Headline
Target action (link to asset, page, or external)
Validity dates (start & end)
Managed via: Admin panel with upload and scheduling support

2. Sectors
Endpoint: /api/categories/list
Returns: List of investment sectors with:
Name
Icon/image reference
Category slug or ID
Usage: Used for filtering Explore and rendering sector tiles

3. Top Assets
Endpoint: /api/home/top-assets
Returns: Highlighted assets with fields like:
Title
ROI/APY
Image
Category
Location
Asset ID for navigation
Data source: Dynamic from pools or manually flagged in backend

4. Learn Cards
Endpoint: /api/home/learn
Returns: Blog/education entries with:
Title
Language tag (e.g. ar/en)
Content type or category

URL to markdown or article

Editable via: Admin content manager

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

