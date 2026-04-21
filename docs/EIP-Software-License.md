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
Implementations conforming to PPSLS MUST expose a consistent interface for license verification and lifecycle management, enabling interoperability across decentralized applications and licensing platforms.

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

- 
# Technical Specification: Smart Contracts for Software Licensing

## 1. Required Functions

### Software Registration
```solidity
function registerSoftware(bytes32 hash) external returns (uint256 softwareId);
```
- Registers software and assigns ownership to the caller.
- **Parameters:** `hash` - A unique identifier (e.g., IPFS hash of documentation or code metadata).
- **Returns:** `softwareId` - A unique incremental ID.

### License Request
```solidity
function requestLicense(uint256 softwareId) external;
```
- Allows users to request a license.
- **Requirements:** MUST revert if the software does not exist or if the user is blacklisted.

### License Approval
```solidity
function approveLicense(
    uint256 softwareId,
    address user,
    uint64 expiry
) external;
```
- Grants license access to a specific address.
- **Requirements:** MUST only be callable by the software owner.

### License Revocation
```solidity
function revokeLicense(uint256 softwareId, address user) external;
```
- **Soft Revocation:** Disables the license without deleting the historical record.

### Blacklisting
```solidity
function blacklistUser(uint256 softwareId, address user) external;
```
- **Hard Revocation:** Prevents all future access and license requests for the specified user.

### License Verification
```solidity
function verifyLicense(uint256 softwareId, address user) external view returns (bool);
```
**A license is valid only if the user is:**
1. Approved
2. Not blacklisted
3. Not revoked
4. Not expired (current timestamp < `expiry`)

---

## 2. Advanced Features

### Optional: Signature-Based Approval
```solidity
function approveWithSignature(
    uint256 softwareId,
    address user,
    uint64 expiry,
    bytes calldata signature
) external;
```
- Enables off-chain approval via signed messages.
- **Requirements:** MUST verify the signer is the software owner using ECDSA recovery.

---

## 3. Privacy Extensions 

Implementations may include the following to address transparency concerns:

* **Hashed Identity Commitments:** Replace public addresses with hashed identities to prevent direct identity exposure on the ledger.
* **Zero-Knowledge Proof (ZKP) Verification:** Use frameworks like **Noir** to prove license ownership without revealing the user's specific identity.
* **Off-Chain License Storage:** Store full license terms off-chain (e.g., IPFS/Arweave) and keep only cryptographic hashes on-chain to maintain data privacy.

---

## 4. Rationale

### On-Chain Enforcement
By implementing this logic directly within a smart contract, the system ensures:
* **Deterministic Verification:** The rules for license validity are immutable and code-driven.
* **Trustless Enforcement:** No central intermediary is required to validate if a user has access.
* **Public Auditability:** The state of software ownership and global blacklists can be verified by any stakeholder.

> **Note:** While on-chain enforcement provides security, it introduces transparency challenges that the Privacy Extensions aim to mitigate.
---

### 5. Revocation & Enforcement Model
Real-world licensing requires dynamic control over access. This standard utilizes a two-tier enforcement system:
* **Soft Revocation:** Disables a specific license (e.g., for non-payment) without erasing the historical record.
* **Blacklisting:** A permanent enforcement level that overrides all other states, preventing a specific address from ever requesting or holding a license for that `softwareId`.

### 6. Signature-Based Approval
By implementing `approveWithSignature`, the system gains three primary benefits:
1.  **Gas Efficiency:** The software owner does not need to send a transaction for every user; they simply provide a signature to the licensee.
2.  **Off-Chain Workflows:** Licenses can be issued via traditional web dashboards or email.
3.  **Privacy Support:** Enables authorization without revealing the owner's direct interaction with every user on-chain.

---

### 7. Rationale & Design Philosophy
The **Privacy-Preserving Software License Standard (PPSLS)** balances the inherent transparency of Ethereum with the confidentiality requirements of commercial software.

* **On-Chain Enforcement:** Ensures deterministic, trustless verification and public auditability of software ownership.
* **Trade-offs:** While on-chain storage is utilized for simplicity, we acknowledge that address-based systems expose usage patterns. This standard provides a baseline that is intentionally extensible to **ZK-proofs** and **MPC (Hawk model)** to hide sensitive conditions.

---

### 8. Security Considerations
* **Signature Replay Attacks:** Implementations MUST include the contract address, `chainId`, and `softwareId` in the signed message to prevent the same signature from being used across different contracts or software products.
* **Blacklist Bypass:** The `verifyLicense` function MUST check the blacklist status first. Blacklist status MUST override `approved` and `expiry` states.
* **Privacy Leakage:** Standard implementations expose licensee identities. For high-privacy use cases, developers should implement the **Privacy Extensions** (Identity Commitments or ZK-proofs).
* **Key Compromise:** Since the `owner` key controls all approvals, use of multi-sig wallets or role-based access control (RBAC) is strongly recommended for the `registerSoftware` address.

---

### 9. Reference Implementation
As part of this project, a functional prototype was developed to demonstrate the core logic.

**Implemented Features:**
* Software registration and ownership tracking.
* License request, approval, and on-chain verification.
* Expiry-based validation logic.
* Two-tier revocation (Revoke vs. Blacklist).

**Experimental/Future Work:**
* **Zero-Knowledge Licensing:** Integration of **Noir** for anonymous verification.
* **MPC-Based Contracts:** Implementing the **Hawk model** to split logic into public/private components.
* **Attestation Integration:** Leveraging the **Ethereum Attestation Service (EAS)** for interoperable identity claims.
* **Merkle-Based Scaling:** Transitioning to Merkle proofs to reduce on-chain storage costs for large-scale user bases.

---

### 10. Backwards Compatibility
This standard is fully compatible with existing Ethereum smart contracts. It does not require protocol-level changes and allows existing software management systems to migrate incrementally by wrapping current license databases into the `registerSoftware` workflow.

### 11. Conclusion
This proposal outlines a practical path toward the adoption of blockchain-based licensing. By combining immutable on-chain enforcement with optional off-chain privacy mechanisms, we provide a foundation that meets both the transparency needs of open-source and the privacy requirements of enterprise software.
