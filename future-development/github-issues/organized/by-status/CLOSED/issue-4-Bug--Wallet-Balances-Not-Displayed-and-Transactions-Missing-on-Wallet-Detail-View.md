# Issue #4: Bug: Wallet Balances Not Displayed and Transactions Missing on Wallet Detail View

**URL**: https://github.com/hossaryp/beta/issues/4
**Status**: CLOSED
**Author**: hossaryp
**Created**: 6/19/2025
**Updated**: 6/22/2025
**Categories**: testing, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Problem Summary
In the Wallets tab of the Pend Explorer, wallet balances are not showing correctly. Additionally, clicking on any wallet does not display the transaction history for that specific wallet.

Scope of the Bug

- Wallet list view does not show:
- Token balances (e.g., pEGP, HVT)
- Phone metadata (if available)
- Last activity or transaction count

Wallet detail view (when clicked) fails to:
- Load associated transaction history
- Show basic wallet metadata
- Provide links to related actions (deposits, redemptions, consents)

🔍 Expected Behavior

- Wallet tab should list:
- wallet address
- pEGP balance
- HVT balance
- last active timestamp
- transaction count

Wallet detail view should show:

- Filtered list of transactions only for that wallet
- Grouped by action (e.g., deposit, send, redeem, consent)
- Expandable details (date, NAV, value, counterparties)




✅ Acceptance Criteria

-  Wallet list loads all balances and metadata correctly
- Clicking a wallet shows its unique transaction history
- Consent, investment, and transfer events all mapped and visible
- Search or filter by address returns expected result

🕐 Priority
HIGH – impacts trust, usability, and debugging; blocks investor visibility into wallet activity



---

## Integration Impact

### Admin Panel Development
⚠️ Consider impact on admin panel features

### Database Migration  
⚠️ Consider database implications

### PendScan Enhancement
⚠️ Review for PendScan relevance

### Mobile App Development
⚠️ Review mobile compatibility

## Implementation Checklist
- [ ] Review requirements against future development plans
- [ ] Estimate development effort  
- [ ] Identify dependencies
- [ ] Plan testing strategy
- [ ] Consider integration points
- [ ] Update relevant planning documents

