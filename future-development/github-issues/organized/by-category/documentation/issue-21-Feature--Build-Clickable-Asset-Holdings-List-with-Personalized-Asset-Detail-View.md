# Issue #21: Feature: Build Clickable Asset Holdings List with Personalized Asset Detail View

**URL**: https://github.com/hossaryp/beta/issues/21
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/24/2025
**Categories**: frontend, backend, performance, documentation
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
🧠 Problem Summary
Currently, users can see their asset holdings at a glance but cannot view deeper insights into each investment. This limits understanding of performance and restricts user actions. A personalized detail view is needed — similar to the Explore tab but focused on "your investment" (e.g. invested amount, date, returns, actions).

🎯 Objective
Enhance the Asset Holdings List so each card is clickable. On click, users are routed to a new Asset Detail Page that shows:

Overview of the asset (title, image, description)

Personal investment summary (money invested, % return, EGP return, date)

Action buttons: Sell and Buy More

🔍 Scope of Work
✅ UI Requirements: Asset Holdings List
Same horizontal layout as before

Each asset row is clickable

On click → route to /portfolio/:assetId

Use useNavigate from React Router

✅ New Route: /portfolio/:assetId
Example: /portfolio/olive-trees

🖼 Asset Detail Page Layout
📌 Top Section
Asset Image (wide banner or square thumbnail)

Asset Name (e.g. Olive Trees)

Short description (can be mock for now)

📊 Investment Summary Box
Styled Card (bg-[#FFF8F4], rounded-xl, px-4 py-3):

Invested Amount: EGP 7,500

text-base, font-bold, text-black

Return in EGP: +EGP 1,875

text-sm, text-[#FF8A34]

ROI %: +25%

text-sm, same color

Investment Date: Jun 1, 2025

text-xs, text-gray-500

🧾 Asset Overview Section (like Explore tab)
Location (optional)

Asset type: Agriculture, etc.

Description or summary of the asset

Legal/custody info (mocked or skipped)

🟧 CTA Section
Two buttons:

Sell (outlined orange button)

Buy More (filled orange button)

Layout: flex, gap-2, full width on mobile

✅ Data Handling
Use useParams to fetch assetId

Map to mock investment data based on ID

Mock return data per asset:

ts
Copy
Edit
{
  id: 'olive-trees',
  invested: 7500,
  returnEGP: 1875,
  returnPercent: 25,
  date: '2025-06-01',
  name: 'Olive Trees',
  image: '/assets/olive.png',
  description: 'A long-term sustainable agricultural investment...'
}
✅ Acceptance Criteria
 Asset holding cards are clickable

 Clicking navigates to /portfolio/:assetId

 Detail page displays personal investment summary (EGP + % return)

 Includes investment date and action CTAs

 Styled to Pend guidelines (white bg, orange accent, rounded)

 No unnecessary sections like ROI model or documents — only personal info and overview

 Fully mobile responsive

⏳ Priority
HIGH — Key for transparency and user interaction with their real asset investments

![Image](https://github.com/user-attachments/assets/6faea861-c5aa-4247-a20d-aaa232c196fd)


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

