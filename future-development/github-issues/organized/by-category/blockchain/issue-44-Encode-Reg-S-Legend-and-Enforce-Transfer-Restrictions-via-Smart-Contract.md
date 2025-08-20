# Issue #44: Encode Reg S Legend and Enforce Transfer Restrictions via Smart Contract

**URL**: https://github.com/hossaryp/beta/issues/44
**Status**: OPEN
**Author**: hossaryp
**Created**: 6/30/2025
**Updated**: 6/30/2025
**Categories**: frontend, blockchain, security, devops
**Priority**: critical
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Labels: compliance, smart-contract, reg-s, high-priority

📌 Description
To comply with Regulation S Rule 144, all securities must:

Carry a restrictive legend (visible + encoded).

Prevent resale to U.S. persons or within the U.S. for 1 year, unless registered or exempt.

This protects downstream holders and notifies brokers/investors of resale restrictions.

✅ Acceptance Criteria
 Add Reg S restrictive legend to token metadata (ERC-20 and/or NFT):


"This security is restricted. It may not be offered or sold in the United States or to U.S. persons unless registered under the Securities Act of 1933 or exempt from registration under Regulation S or Rule 144."
 In the AssetFactory and TransferAgent contracts:

Tag each security/token with a regS_lockUntil timestamp at mint.

If sender or recipient is marked as U.S. or has U.S. IP/identity, block the transfer unless block.timestamp > lockUntil.

 Add onlyAfterRegSUnlock(address from, address to) modifier or logic.

 Exempt whitelisted smart contracts (e.g. redemption or treasury).

🧠 Developer Notes
Consider reusing ConsentManager.getJurisdiction(wallet) for U.S. detection.

Lock period = 365 days from issuance.

Apply to both transfer() and transferFrom() paths.

Display warning on frontend if transfer is attempted during lock period.



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

