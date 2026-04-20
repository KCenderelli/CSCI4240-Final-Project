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
