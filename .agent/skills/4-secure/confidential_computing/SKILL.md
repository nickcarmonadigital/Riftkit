---
name: Confidential Computing
description: Protect data in use with TEEs (Intel SGX, AMD SEV, ARM TrustZone), remote attestation, Confidential VMs, Gramine, and EGo for secure enclave development.
triggers:
  - /confidential-computing
  - /tee
  - /secure-enclave
---

# Confidential Computing

## WHEN TO USE

- Running sensitive workloads where the cloud provider or host OS is untrusted
- Deploying Intel SGX enclaves for secret computation (key management, private inference)
- Using AMD SEV-SNP or Intel TDX for Confidential VM isolation
- Implementing remote attestation to verify enclave integrity before sharing secrets
- Porting existing applications to enclaves with Gramine (LibOS) or EGo (Go)
- Building multi-party computation pipelines where no single party sees all data
- Protecting ML models or trading algorithms during execution

## PROCESS

1. **Assess the threat model** — identify what you are protecting (data, code, models) and from whom (cloud admin, co-tenant, OS compromise). This determines TEE choice: SGX for process-level, SEV-SNP/TDX for VM-level.
2. **Select TEE platform** — Intel SGX for small TCB and fine-grained control. AMD SEV-SNP for lift-and-shift VM workloads. ARM TrustZone for edge/mobile. Azure DCsv3/DCdsv3 for SGX, GCP C3 for TDX.
3. **Choose development framework** — Gramine for running unmodified Linux apps in SGX. EGo for native Go enclave apps. Intel SGX SDK for C/C++ with `sgx_ecall`/`sgx_ocall` boundary. Open Enclave SDK for cross-platform.
4. **Define the enclave boundary** — minimize the Trusted Computing Base. Only place security-critical logic inside the enclave. Data crosses the boundary via `ecalls` (into enclave) and `ocalls` (out).
5. **Implement attestation** — use DCAP (Data Center Attestation Primitives) for SGX or AMD SEV-SNP attestation reports. Verify quotes against Intel/AMD root of trust. Integrate with Azure Attestation or custom verifier.
6. **Seal and provision secrets** — use SGX sealing (`sgx_seal_data`) for local persistence. For remote provisioning, establish an attested TLS channel (RA-TLS) before transmitting secrets.
7. **Handle side-channel risks** — mitigate known attacks: disable hyperthreading on SGX hosts, use constant-time code for crypto, apply ORAM for memory access patterns, keep enclave code minimal.
8. **Deploy Confidential VMs** — for VM-level isolation, launch Azure Confidential VMs (DCasv5) or GCP Confidential VMs. Verify attestation at boot. Use vTPM for measured boot chain.
9. **Monitor and audit** — log attestation verification results, enclave lifecycle events, and sealed data access. Alert on attestation failures or unexpected enclave measurements.

## CHECKLIST

- [ ] Threat model documented — attacker capabilities and trust boundaries defined
- [ ] TEE platform selected and hardware/cloud availability confirmed
- [ ] TCB minimized — only critical code runs inside the enclave
- [ ] Remote attestation flow implemented and tested end-to-end
- [ ] Secrets provisioned only after successful attestation verification
- [ ] Side-channel mitigations applied (HT disabled, constant-time crypto)
- [ ] Sealed data recovery tested after enclave restart
- [ ] Confidential VM attestation verified at boot (if using CVM)
- [ ] Performance overhead measured and acceptable (< 2x for compute-bound)

## Related Skills

- `homomorphic_encryption` — compute on encrypted data without TEE hardware
- `zero_knowledge_applications` — prove computation correctness without revealing inputs
