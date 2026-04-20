
# Privacy Model

## Overview

This project operates under the assumption that **fully transparent smart contracts are incompatible with real-world software licensing**. As a result, the system adopts a **selective transparency model**, where only necessary information is exposed on-chain.

---

## Privacy Goals

1. **Protect User Identity**
   - Prevent direct linkage between real-world identity and blockchain address

2. **Protect License Terms**
   - Avoid exposing proprietary or sensitive licensing agreements

3. **Enable Public Verifiability**
   - Allow third parties to verify license validity without revealing private data

---

## Current Privacy Model (Baseline)

### What is Public

- Software ownership (Ethereum address)
- License status:
  - Approved / revoked
  - Expiry timestamp
- User addresses interacting with the contract

### What is Private (Implicit / Off-Chain)

- Real-world identity of users
- Full license agreements
- Usage context of the software
- Rationale for approval or revocation

---

## Limitations of Current Model

The current implementation exposes:
- User addresses → can be deanonymized through transaction analysis
- Access patterns → visible on-chain

This creates a **pseudonymous system**, not a fully private one.

---

## Privacy Enhancements (Explored)

### 1. Zero-Knowledge Proofs (ZKPs)

Using Noir, the system can evolve to:
- Prove license ownership without revealing identity
- Verify eligibility without exposing underlying data

**Example:**
A user proves:
> "I hold a valid license for software X"

Without revealing:
- Their address
- The license details

---

### 2. Hawk-Style MPC Contracts

Inspired by Hawk:
- Contract logic is split into:
  - Public on-chain commitments
  - Private off-chain computation

Benefits:
- Hidden contract terms
- Reduced on-chain leakage

---

### 3. Trusted Execution Environments (TEEs)

- Execute sensitive logic off-chain in secure enclaves
- Only publish attestations to the blockchain

---

### 4. Ethereum Attestation Service (EAS)

- Replace direct mappings with attestations
- Allow:
  - Third-party verification
  - Revocable credentials
  - More flexible identity abstraction

---

## Target Privacy Model (Ideal)

A fully realized system would provide:

- **Anonymity:** Users are not directly identifiable
- **Confidentiality:** License terms are hidden
- **Verifiability:** Valid licenses can still be proven
- **Revocability:** Access can be dynamically revoked

---

## Key Insight

Privacy is not optional—it is required for:
- Commercial adoption
- Enterprise use cases
- Real-world legal compliance

---

## Summary

The current implementation serves as a **transparent baseline**, while the broader project explores transitioning toward a **privacy-preserving smart contract model** using ZK proofs, MPC, and attestation systems.
