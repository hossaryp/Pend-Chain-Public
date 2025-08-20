# Issue #6: Feature: Show Payment Options When Depositing EGP

**URL**: https://github.com/hossaryp/beta/issues/6
**Status**: CLOSED
**Author**: hossaryp
**Created**: 6/19/2025
**Updated**: 6/22/2025
**Categories**: frontend, backend, testing, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
Currently, when a user clicks "Deposit EGP", the flow proceeds without allowing the user to choose a payment method. This limits flexibility, causes confusion, and doesn’t reflect backend integrations (Coinbase, Binance, Bank Transfer, etc.).

🎯 Objective
Introduce a payment options screen after selecting "Deposit EGP", allowing the user to choose between available funding methods.

🧩 Scope
1. Payment Method Selection UI
After user clicks "Deposit EGP":

Show a modal or full-screen with the following options:

🏦 Bank Transfer

🍏 Apple Pay

🤖 Google Pay

🌐 Coinbase

🟡 Binance Pay

(future) 💳 Card Payment

mobile walleyt (if possible) 

Each option should be a selectable card/button with logo and description

2. Option-Specific Handling
Clicking on a payment method should:

Trigger the appropriate backend flow (e.g., generate transfer reference, redirect to Coinbase, etc.)

Store selected method in transaction metadata

when payment is confiremed proceed to back end minting flow

3. Metadata Logging
Include paymentMethod in deposit logs and explorer:

j
✅ Acceptance Criteria
 Payment method selection screen shown after "Deposit EGP"

 User cannot skip selection step

 Each option routes to the correct handler

 Transaction includes selected paymentMethod

 Logged on-chain and in Explorer/API

⏳ Priority
HIGH – improves UX, ensures integration alignment, and prepares for fiat onboarding scale



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

