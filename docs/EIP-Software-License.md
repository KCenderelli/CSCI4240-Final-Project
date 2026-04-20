---
eip: Draft
title: Privacy-Preserving Software License Standard
author: Kira, Daria, Zunni
status: Draft
type: Standards Track
category: ERC
created: 2026-04-20
---

# Privacy-Preserving Software License Standard (PPSLS)

## Abstract

This proposal defines a standardized framework for managing software licenses on Ethereum-based smart contracts while preserving user privacy and enabling enforceable revocation. Existing blockchain-based licensing systems are fully transparent, exposing user-license relationships and making it difficult to support privacy-preserving or trust-minimized software distribution.  

The Privacy-Preserving Software License Standard (PPSLS) introduces a unified interface for issuing, verifying, and revoking software licenses while supporting optional signature-based authorization and privacy-preserving identity handling. This standard enables developers to track software usage, enforce licensing restrictions, and revoke access when necessary without permanently exposing user identities on-chain.

---

## Motivation

Current blockchain-based licensing systems suffer from three major limitations:

1. **Lack of Privacy**
   - License ownership is permanently visible on-chain.
   - User addresses are directly linked to software usage history.
   - This discourages adoption in commercial or sensitive applications.

2. **Limited Revocation Mechanisms**
   - Many smart contract licensing systems lack robust revocation logic.
   - Even when revocation exists, it is often not enforced consistently in verification logic.

3. **Lack of Standardization**
   - Each implementation defines its own license structure and verification rules.
   - This prevents interoperability across dApps and licensing systems.

This proposal addresses these issues by introducing a standardized interface that supports:
- License issuance with optional expiry
- Revocation and blacklisting mechanisms
- Signature-based approval workflows
- Privacy-preserving design patterns for future extensions (e.g., hashed identity commitments or zero-knowledge proofs)


2. Required Functions
Software Registration
function registerSoftware(bytes32 hash) external returns (uint256 softwareId);
Registers software and assigns ownership to caller
License Request
function requestLicense(uint256 softwareId) external;
Allows users to request a license
MUST revert if software does not exist or user is blacklisted
License Approval
function approveLicense(
    uint256 softwareId,
    address user,
    uint64 expiry
) external;
Grants license access
MUST only be callable by software owner
License Revocation
function revokeLicense(uint256 softwareId, address user) external;
Soft revocation (disables license without deleting record)
Blacklisting
function blacklistUser(uint256 softwareId, address user) external;
Hard revocation
Prevents all future access and requests
License Verification
function verifyLicense(uint256 softwareId, address user) external view returns (bool);

A license is valid only if:

Not blacklisted
Approved
Not revoked
Not expired
Optional: Signature-Based Approval
function approveWithSignature(
    uint256 softwareId,
    address user,
    uint64 expiry,
    bytes calldata signature
) external;
Enables off-chain approval via signed messages
MUST verify signer is software owner
3. Privacy Extensions (Optional)

Implementations MAY include:

Hashed Identity Commitments
Replace addresses with hashed identities
Prevent direct identity exposure
Zero-Knowledge Proof Verification
Prove license ownership without revealing identity
Enable anonymous verification
Off-Chain License Storage
Store full license terms off-chain
Keep only hashes on-chain
Rationale
On-Chain Enforcement

On-chain logic ensures:

Deterministic verification
Trustless enforcement
Public auditability

However, it introduces transparency challenges.

Revocation Model

Real-world licensing requires:

Expiration handling
Misuse enforcement

Two levels are used:

Soft revoke (temporary / informational)
Blacklist (permanent)
Signature-Based Approval

Benefits:

Reduces gas usage
Enables off-chain workflows
Supports privacy extensions
Privacy Limitations

Ethereum is inherently transparent:

All state is public
All interactions are traceable

Thus, privacy must be achieved through:

ZK proofs
MPC systems
Off-chain computation
Design Philosophy

This standard provides:

A simple, enforceable baseline
Optional advanced privacy extensions
Security Considerations
Signature Replay Attacks
Include contract address and parameters in signed message
Prevent cross-contract reuse
Blacklist Enforcement
Verification MUST check blacklist first
Blacklist overrides all states
Expiry Enforcement
Expiry timestamps MUST be checked
Avoid reliance on off-chain timing
Key Compromise
Owner key compromise enables unauthorized approvals
Mitigation:
Multi-sig wallets
Role-based controls
Privacy Leakage
Address-based systems expose usage patterns
Requires ZK or identity abstraction for mitigation
Gas and Storage Costs
Per-user mappings are expensive
Future systems MAY use:
Merkle proofs
Off-chain storage
Backwards Compatibility
Compatible with existing Ethereum smart contracts
No protocol-level changes required
Existing systems can migrate incrementally
Reference Implementation

A reference implementation was developed as part of this project.

Implemented Features
Software registration
License request and approval
Expiry-based validation
Revocation and blacklisting
On-chain verification logic
Not Implemented (Yet)
Signature-based approval
Zero-knowledge proof integration (Noir)
Identity commitment schemes
Attestation-based verification
Future Work
Zero-Knowledge Licensing
Anonymous license verification
Identity abstraction
MPC-Based Contracts (Hawk Model)
Split contract logic into public and private components
Hide sensitive conditions
Trusted Execution Environments (TEEs)
Execute confidential logic off-chain
Publish attestations on-chain
Ethereum Attestation Integration
Replace mappings with attestations
Enable interoperability across systems
Merkle-Based License Systems
Store licenses as commitments
Verify via inclusion proofs
Reduce gas costs
Conclusion

The Privacy-Preserving Software License Standard (PPSLS) establishes a foundation for blockchain-based software licensing that balances transparency, enforceability, and privacy.

By combining:

On-chain verification
Off-chain privacy mechanisms

this proposal outlines a practical path toward real-world adoption of smart contract–based licensing systems.
---

## Specification

License structure:
softwareId
license hash
expiry
revoked flag
optional privacy layer
Functions:
registerSoftware()
approveLicense()
revokeLicense()
verifyLicense()
approveWithSignature()

Privacy extension idea (important for your paper angle):

Propose:

hashed identity commitments
optional zk-proof verification (even if not implemented fully)
signature-based authorization without revealing identity publicly

### 1. Core Data Structures

Each compliant implementation MUST define the following structures:

```solidity
struct Software {
    address owner;
    bytes32 hash;
    bool exists;
}

struct License {
    bool approved;
    bool revoked;
    uint64 expiry;
}



## Rationale

Explain tradeoffs:

why on-chain storage is used
why revocation is necessary
why signature-based approval is better than direct assignment
why full privacy is hard on Ethereum


## Security Considerations

Include:

signature replay attacks
blacklist bypass risks
expiry enforcement
key compromise risk
on-chain transparency leaks identity patterns
gas/storage tradeoffs

## Backwards Compatibility



## Reference Implementation

What we were able to implement
