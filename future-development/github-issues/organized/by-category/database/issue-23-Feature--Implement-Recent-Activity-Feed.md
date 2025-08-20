# Issue #23: Feature: Implement Recent Activity Feed

**URL**: https://github.com/hossaryp/beta/issues/23
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/24/2025
**Categories**: frontend, database, security, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
Users need visibility into their most recent actions — investments, redemptions, or pending transactions — to build trust and give feedback on platform interactions. Currently, there is no activity log in the Your Investments tab, leaving users unaware of what actions have been executed or are in progress.

🎯 Objective
Display a clean, mobile-friendly activity feed showing the user's 4 most recent transactions. Each entry should clearly state the action, amount, timestamp, and transaction status using visual tags.

🔍 Scope of Work
✅ Section Header
Title: Recent Activity

Style: text-sm, font-semibold, text-black

Padding: px-4, mt-6, mb-2

✅ Activity Item Layout (List Item)
Each item should include:

Action Text:

Examples:

Invested in Gold Reserve

Sold Date Farm

Style: text-sm, font-medium, text-black

Amount + Timestamp:

E.g. EGP 1,500 — Jun 20, 11:08 AM

Style: text-xs, text-gray-500

Status Tag:

Right-aligned pill tag

Text:

Successful

Pending

Rejected

Styling:

Base: text-xs, px-2 py-1, rounded-full

Background color varies by status:

Successful: neutral gray

Pending: soft orange

Rejected: light gray

Card/List Style:

Use vertical list with spacing between items (gap-3, mb-1)

Optional Card wrapping each row, or border-bottom

✅ Mock Data Format
ts
Copy
Edit
const activity = [
  {
    id: 1,
    action: "Invested in Gold Reserve",
    amount: "EGP 3,600",
    time: "Jun 24, 10:03 AM",
    status: "Successful"
  },
  {
    id: 2,
    action: "Sold Date Farm",
    amount: "EGP 1,500",
    time: "Jun 20, 2:48 PM",
    status: "Successful"
  },
  {
    id: 3,
    action: "Invested in Olive Trees",
    amount: "EGP 7,500",
    time: "Jun 18, 9:12 AM",
    status: "Pending"
  },
  {
    id: 4,
    action: "Redemption of Gold Reserve",
    amount: "EGP 1,200",
    time: "Jun 17, 6:01 PM",
    status: "Rejected"
  }
]
✅ Acceptance Criteria
 Section titled “Recent Activity” below the Portfolio Allocation component

 4 most recent actions shown in clean list format

 Each item displays action, amount, time, and status

 Status tags styled with appropriate colors and shape

 List is fully responsive and styled with proper spacing

 No extra features like filters, scroll, or action buttons

⏳ Priority
HIGH — Core part of investment feedback loop and user trust

![Image](https://github.com/user-attachments/assets/7f875435-aaaa-4149-9e39-2bbb4bd00a8f)

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

