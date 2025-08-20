# Issue #12: Feature Deposit Request Creation and Status Tracking

**URL**: https://github.com/hossaryp/beta/issues/12
**Status**: CLOSED
**Author**: Hegazyy12
**Created**: 6/22/2025
**Updated**: 6/22/2025
**Categories**: frontend, backend, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
📌 Problem Summary
When a user initiates a deposit, the system currently lacks a structured way to track the full deposit lifecycle — from initiation to approval or failure. Without proper logging and status visibility, users can't verify their deposit state or trust the minting logic.

🎯 Objective
Implement a complete deposit request system with status tracking and user-facing history, tied to backend approval logic and minting events.

🧩 Scope

Deposit Request Handling

When user initiates a deposit:

Create a deposit request object with:

amount

paymentMethod (from selected method)

status: pending

timestamp

userIdentityHash

Status Lifecycle

Backend updates the status based on verification:

approved: Trigger EGP stablecoin minting

failed: Do not mint, initiate refund by method rules

Minting

Mint only happens after backend sets status = approved

Log minting event with reference to deposit ID

User Interface

Deposit history view shows:

List of past deposit requests

Method used

Status (pending, approved, failed)

Date/time

Explorer Logging

Status updates and deposit metadata should be logged on-chain or via the internal explorer/API

✅ Acceptance Criteria

Deposit requests are created on every user deposit

Status updates are tracked and reflected in the UI

Minting only happens after approved status

User sees a complete deposit history with status and timestamps

Failed deposits are handled gracefully

⏳ Priority
HIGH – Essential for trust, fund traceability, and stablecoin issuance control

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

