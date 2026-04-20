
# Architecture Overview

## High-Level Design

The system is built around a smart contract–based licensing registry deployed on Ethereum. The architecture separates **on-chain enforcement logic** from **off-chain privacy-presing mechanisms**, enabling selective transparency.

### Core Components

1. **Smart Contract (On-Chain)**
   - Acts as the source of truth for:
     - Software registration
     - License issuance
     - Revocation and blacklisting
   - Maintains mappings:
     - `softwareId → Software`
     - `softwareId → user → License`
     - `softwareId → user → blacklist status`

2. **Users**
   - Request licenses for specific software IDs
   - Interact directly with the contract using Ethereum addresses

3. **Software Owners (Admins)**
   - Register software
   - Approve or revoke licenses
   - Blacklist malicious users

4. **Off-Chain Layer (Planned / Partial)**
   - Zero-Knowledge Proof generation (via Noir)
   - Identity abstraction (future work)
   - Storage of sensitive license terms

---

## Data Flow

### 1. Software Registration
- Owner calls `registerSoftware(hash)`
- Contract assigns a unique `softwareId`
- Stores:
  - Owner address
  - Software hash (off-chain reference)

### 2. License Request
- User calls `requestLicense(softwareId)`
- Contract checks:
  - Software exists
  - User is not blacklisted
- Initializes a pending license

### 3. License Approval
- Owner calls `approveLicense(...)`
- License becomes active with:
  - `approved = true`
  - `expiry` timestamp

### 4. Verification
- Anyone can call `verifyLicense(...)`
- Contract checks:
  - Not blacklisted
  - Approved
  - Not revoked
  - Not expired

### 5. Revocation / Blacklisting
- **Soft revoke:** disables license but preserves history
- **Blacklist:** permanently invalidates access and blocks future requests

---

## Design Principles

### 1. Minimal On-Chain Storage
Only essential state is stored on-chain:
- Ownership
- License status
- Expiry

Sensitive data (e.g., full license terms, identity) is intentionally excluded.

### 2. Deterministic Enforcement
All license validity checks are:
- Stateless beyond stored mappings
- Deterministic
- Publicly verifiable

### 3. Extensibility
The system is designed to integrate with:
- Zero-Knowledge Proof systems (Noir)
- MPC-based systems (e.g., Hawk)
- Ethereum Attestation frameworks

---

## Future Architecture Extensions

- **ZK-based license verification**
  - Replace direct address checks with proof-based identity
- **Confidential contract logic**
  - Move license terms off-chain while keeping enforcement on-chain
- **Decentralized identity integration**
  - Use attestations instead of raw addresses

---

## Summary

The architecture demonstrates a hybrid model:
- **On-chain:** enforcement, auditability
- **Off-chain:** privacy, scalability

This split is essential for making blockchain-based software licensing viable in real-world scenarios.
