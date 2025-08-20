# Issue #18: Feature: Implement Global Header with Notification Modal for Pend Beta App

**URL**: https://github.com/hossaryp/beta/issues/18
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/30/2025
**Categories**: frontend, database, security, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
The current Pend Beta mobile app lacks a consistent global header. Users need a unified top bar across all screens that displays the app identity and provides access to real-time notifications. Without this, the app lacks cohesion and users miss important updates about their activity.

🎯 Objective
Build a global, mobile-first header component used across the Pend app. It should include:

Centered branding (pend, lowercase)

Right-aligned notification bell

On-click: Opens modal with recent alerts

Fully responsive, no layout overlap or scroll bugs

🔍 Scope of Work
✅ UI Requirements
Layout:

Fixed or sticky to top (depending on screen design)

Full-width container, white background

Padding: px-4 py-2, rounded-none

Shadow: shadow-sm

Branding:

Centered: pend

Style: lowercase, font-bold, font-[Poppins], text-black, text-lg

Notification Icon:

Right-aligned bell icon (use lucide-react or heroicons)

Click toggles dropdown/modal

✅ Notification Modal
White rounded-xl card or floating modal

Max height ~300px, scrollable if overflow

Shadow: shadow-lg, z-index above main content

Each notification item:

Title (bold, black)

Timestamp (text-xs, gray-500)

Optional status tag (e.g. ✅, ❗ — or simple styled dots if no emojis)

"Clear All" button:

Small, text-[#FF8A34], aligned right

On click: clears notification list (in-memory)

✅ Example Notification List (initial mock state)
ts
Copy
Edit
[
  {
    id: 1,
    type: "success",
    message: "You successfully purchased Gold Reserve",
    timestamp: "Jun 24, 10:03 AM"
  },
  {
    id: 2,
    type: "success",
    message: "You sold Date Farm",
    timestamp: "Jun 20, 2:48 PM"
  },
  {
    id: 3,
    type: "pending",
    message: "Your investment in Olive Trees is pending",
    timestamp: "Jun 18, 9:12 AM"
  }
]
✅ Acceptance Criteria
 Global header appears on all screens and is consistent

 pend text is centered and styled according to brand

 Bell icon opens notification modal

 Modal displays 3 sample alerts, styled with spacing and timestamp

 "Clear All" button clears alerts and collapses modal if needed

 Uses Tailwind for layout and styling (rounded-xl, shadow-sm, etc.)

 No emojis used — status conveyed by color, icon, or bold

 Responsive on mobile screens (min width: 360px)

⏳ Priority
HIGH — Core to global layout, brand consistency, and user feedback UX

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

