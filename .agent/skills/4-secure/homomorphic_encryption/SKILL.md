---
name: Homomorphic Encryption
description: Implement fully homomorphic encryption using TFHE, BFV, CKKS schemes with Microsoft SEAL, concrete-ml, and Zama for encrypted inference, private set intersection, and secure computation.
triggers:
  - /fhe
  - /homomorphic
  - /encrypted-computation
---

# Homomorphic Encryption

## WHEN TO USE

- Running ML inference on encrypted data without decryption (encrypted inference)
- Computing on sensitive data where neither party should see the other's input
- Implementing private set intersection for ad matching, contact tracing, or fraud detection
- Building encrypted search or database queries
- Choosing between FHE schemes: TFHE (fast bootstrapping), BFV (integer arithmetic), CKKS (approximate real arithmetic)
- Evaluating FHE feasibility vs alternatives (TEEs, MPC, ZKP)

## PROCESS

1. **Assess feasibility** — FHE adds 1000-1,000,000x overhead depending on circuit depth. Determine if the computation is simple enough (low multiplicative depth) or if TFHE programmable bootstrapping keeps it manageable.
2. **Select the scheme** — TFHE for boolean/small-integer circuits with programmable bootstrapping (Zama's concrete). BFV for exact integer arithmetic (batched). CKKS for approximate real-number computation (ML inference).
3. **Choose the library** — Microsoft SEAL (C++/Python, BFV+CKKS). Zama concrete-ml for ML-on-encrypted-data with scikit-learn API. OpenFHE for research flexibility. Zama TFHE-rs for Rust-native TFHE.
4. **Set parameters** — configure polynomial modulus degree (`poly_modulus_degree`), coefficient modulus chain, and plaintext modulus. Balance security level (128-bit), noise budget, and performance. Use `seal.sec_level_type.tc128`.
5. **Encode and encrypt** — for CKKS: use `CKKSEncoder` to pack real vectors into plaintext slots, then encrypt. For BFV: use `BatchEncoder` for SIMD integer packing. For TFHE: encrypt individual bits or small integers.
6. **Implement the circuit** — express computation as additions and multiplications on ciphertexts. Minimize multiplicative depth. Use `relinearize` after each multiplication and `rescale` for CKKS to manage noise.
7. **Optimize with concrete-ml** — for ML models, use `concrete-ml` to compile scikit-learn or PyTorch models to FHE circuits automatically. Quantize weights to reduce bit-width. Use `compile()` with representative dataset.
8. **Benchmark** — measure encryption time, computation time, decryption time, and ciphertext size. Compare against plaintext baseline. Profile noise budget consumption per operation.
9. **Deploy** — serve encrypted inference via API: client encrypts input, sends ciphertext, server computes on ciphertext, returns encrypted result, client decrypts. Never expose secret keys server-side.

## CHECKLIST

- [ ] Computation profiled — multiplicative depth and operation count mapped
- [ ] FHE scheme matches the workload (TFHE for boolean, BFV for integer, CKKS for real)
- [ ] Parameters provide 128-bit security (verified against HE Standard)
- [ ] Noise budget sufficient for full computation (no decryption failures)
- [ ] Ciphertext size acceptable for network transfer (< 100MB per inference)
- [ ] End-to-end latency measured and within application tolerance
- [ ] Key management implemented — secret key never leaves client
- [ ] Correctness validated — decrypted results match plaintext computation
- [ ] concrete-ml model quantization tested for accuracy degradation (< 2% drop)

## Related Skills

- `confidential_computing` — hardware-based alternative for data-in-use protection
- `zero_knowledge_applications` — prove correctness of encrypted computation
