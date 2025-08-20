# Issue #28: Feature: Build Bottom Navigation Bar for Pend Beta App

**URL**: https://github.com/hossaryp/beta/issues/28
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/25/2025
**Categories**: frontend, backend, security, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary

The Pend Beta app currently lacks a consistent bottom navigation bar for screen switching. Without it, users cannot easily move between core areas like Explore, My Investment, and Profile. A sticky mobile nav bar is essential for usability, discoverability, and a polished app experience.

🎯 Objective

Create a **3-tab mobile navigation bar** fixed at the bottom of the screen, enabling smooth navigation between:

1. Explore
2. My Investment
3. Profile

It should follow Pend’s branding (icon-first, minimal labels, orange highlight for active tab).



🔍 Scope of Work

✅ Layout & Styling

* **Container:**

  * Fixed to bottom (`fixed bottom-0 left-0 right-0`)
  * Background: white
  * Shadow: `shadow-md`
  * Padding: `py-2 px-6`
  * Flex layout: `flex justify-between items-center`

* **Tab Item:**

  * Icon (SVG or from lucide-react)
  * Label below icon (e.g., `Explore`, `Profile`)
  * Font: `Poppins`, `text-xs`, `text-center`
  * Layout: vertical (`flex flex-col items-center gap-1`)

* **Active Tab Styling:**

  * Icon and label use brand orange `#FF8A34`
  * Inactive tabs use muted gray `#A3A3A3` or `text-gray-400`

* **Icon Size:**

  * About `24px` width, using viewBox or class sizing

---

✅ Tabs & Routing

| Tab           | Icon                              | Route        |
| ------------- | --------------------------------- | ------------ |
| Explore       | Leaf (🟢 `lucide:leaf`)           | `/explore`   |
| My Investment | Pie Chart (🟠 `lucide:pie-chart`) | `/portfolio` |
| Profile       | User (🟠 `lucide:user`)           | `/profile`   |

* Use `React Router` for navigation
* Active tab detected via `useLocation()`
* Use `onClick` to navigate on tab press


✅ Acceptance Criteria

* [ ] Bar is fixed at bottom and visible on all main screens
* [ ] Tabs include icon + label, with orange styling for active tab
* [ ] Icons match those shown in uploaded screenshot
* [ ] Responsive on all mobile screen sizes (min 360px)
* [ ] Tab click updates route via React Router without reload
* [ ] Smooth transition between pages
* [ ] No top border, no animations, no labels outside of icons


⏳ Priority

**HIGH** — Foundational for user navigation across the app

![Image](https://github.com/user-attachments/assets/c3139bb0-5014-4ab1-824a-bc95b5275996)

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

