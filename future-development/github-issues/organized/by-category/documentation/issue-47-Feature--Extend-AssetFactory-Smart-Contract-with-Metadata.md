# Issue #47: Feature: Extend AssetFactory Smart Contract with Metadata

**URL**: https://github.com/hossaryp/beta/issues/47
**Status**: OPEN
**Author**: Hegazyy12
**Created**: 7/1/2025
**Updated**: 7/1/2025
**Categories**: frontend, backend, blockchain, adminPanel, documentation, devops
**Priority**: high
**Assignees**: Unassigned
**Milestone**: No milestone

## Labels


## Description
Enhance the AssetFactory smart contract to store and expose all relevant metadata required for Explore tab display, investment decisions, and compliance.

User Story:
As a smart contract developer, I want to store asset metadata (including legal and business information) on-chain so that each asset is traceable, transparent, and legally auditable.

Acceptance Criteria:
Update createAsset() and the asset struct to include the following parameters:

string assetName

string sector

string location

string description

string thumbnailId (for backend image matching)

string lockPeriod

string minInvestment

string expectedROI

string roiModel

string managerName (Asset Manager)

string highlights

string impactStatement

string legalDocURL

string businessDocURL

Also:

Emit all fields (except long text) in AssetCreated event

Add a getAsset(uint256 id) view function to return the full metadata

Dependencies:

Admin Panel asset creation UI (Issue 15B)

Frontend rendering in Explore tab (Issue 15C)

FRA Compliance:

 Investment Disclosure

Legal Documentation Availability

Asset Manager Transparency



---

## Integration Impact

### Admin Panel Development
✅ Directly related to admin panel development

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

