# Issue #29: Feature Implement Payment Process Flow on Investment action

**URL**: https://github.com/hossaryp/beta/issues/29
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/24/2025
**Updated**: 6/25/2025
**Categories**: frontend, backend, security, documentation, testing, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
roblem Summary
In Pend Beta, users do not fund a balance in advance. Instead, they initiate a payment directly when investing in an asset. This flow must be simple, clear, and legally compliant — ensuring user agreement, consent, and structured payment instruction before proceeding.

🎯 Objective
Design and implement a payment initiation flow that begins only after the user selects an asset, agrees to investment terms, and confirms consent. The user then selects a payment method and follows instructions to complete the transaction.

🔍 Scope of Work
✅ Entry Point
Triggered from Invest Now CTA on any asset

Investment form appears only after:

User views asset details

User accepts investment terms

Consent signature is recorded via ConsentManager

✅ Payment Method Selection Screen
UI shows available methods:

Bank Transfer

Credit/Debit Card

Layout:

Title: "Select Payment Method"

Each method as a styled card with icon + short description

On selection, proceed to instructions

✅ Payment Instruction Screen
Based on chosen method:

Bank Transfer:

Show: Bank Name, Account Number/IBAN, Reference Code

Instructional text: “Please transfer the exact amount and include your reference code.”

Credit Card:

Show: mock form or placeholder (no actual gateway)

Button: "Confirm Payment" → mock confirmation

CTA Button: "Confirm Payment"

On click:

Store paymentMethod in transaction metadata

Set status to pending

Emit ConsentVerified on-chain

✅ Metadata Logging & Status
Store in backend:

User identity hash

Payment method selected

Asset ID

Consent signature hash

Initial status: pending

Show user:

Confirmation screen: "Payment Pending"

Optional: link to transaction activity or wallet

✅ Acceptance Criteria
 Payment flow starts only after terms are accepted

 User selects payment method: Bank or Card

 Clear, method-specific instructions shown

 Confirm button logs metadata and triggers consent signature

 User sees success confirmation with status pending

 Fully styled to match Pend guidelines (Poppins, orange accents, white background)

 No wallet top-up or balance system used

⏳ Priority
HIGH — Required for compliant and user-friendly investment execution


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

