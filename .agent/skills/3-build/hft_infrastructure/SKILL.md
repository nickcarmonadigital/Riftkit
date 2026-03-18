---
name: HFT Infrastructure
description: Build ultra-low-latency trading systems using kernel bypass (DPDK), lock-free data structures, FPGA order routing, co-location strategies, and tick-to-trade measurement.
triggers:
  - /hft
  - /high-frequency
  - /low-latency-trading
---

# HFT Infrastructure

## WHEN TO USE

- Designing kernel-bypass networking with DPDK, Solarflare OpenOnload, or io_uring
- Implementing lock-free queues, ring buffers, or SPSC data structures for order flow
- Building or integrating FPGA-based order routing and market data parsing
- Optimizing tick-to-trade latency below 10 microseconds
- Setting up co-location infrastructure and network topology
- Analyzing market microstructure for latency arbitrage or market making
- Profiling and eliminating jitter sources (GC, TLB misses, context switches, NUMA)

## PROCESS

1. **Define latency budget** — break down the tick-to-trade path: market data ingestion, signal computation, risk check, order serialization, network transmission. Assign microsecond budgets per stage.
2. **Network layer** — implement kernel bypass with DPDK `rte_eth_rx_burst` / `rte_eth_tx_burst` or Solarflare OpenOnload for socket acceleration. Pin NIC interrupts to dedicated cores.
3. **Data structures** — use lock-free SPSC ring buffers for inter-thread communication. Implement cache-line-aligned order books with `alignas(64)`. Avoid `std::mutex` entirely.
4. **Memory management** — pre-allocate all memory at startup via huge pages (`mmap` with `MAP_HUGETLB`). Eliminate dynamic allocation on the hot path. Use memory pools for order objects.
5. **CPU optimization** — isolate cores with `isolcpus`, disable hyperthreading, pin threads with `pthread_setaffinity_np`. Disable C-states and frequency scaling in BIOS.
6. **FPGA integration** — if using FPGA order routing, define the wire protocol, implement market data parser in HDL, and use PCIe DMA for host communication. Target Xilinx Alveo or Intel Stratix.
7. **Measurement** — instrument with hardware timestamps (NIC PTP), `rdtsc` for cycle counting, or Memory-Mapped I/O timestamping. Build latency histograms, track p50/p99/p999.
8. **Risk checks** — implement pre-trade risk as branchless comparisons on the hot path: position limits, order rate limits, fat-finger checks. Must add < 1 microsecond.
9. **Testing** — replay historical market data through the full stack. Measure latency distributions under load. Verify correctness with exchange conformance test suites.

## CHECKLIST

- [ ] Kernel bypass networking operational (DPDK or OpenOnload)
- [ ] All hot-path allocations eliminated — memory pre-allocated with huge pages
- [ ] Lock-free data structures verified with thread sanitizer and stress tests
- [ ] CPU cores isolated and pinned — no context switches on trading threads
- [ ] Tick-to-trade latency measured end-to-end with hardware timestamps
- [ ] Latency histogram shows acceptable p99 and p999 (no tail spikes)
- [ ] Pre-trade risk checks integrated on hot path with < 1us overhead
- [ ] NUMA topology respected — memory local to trading cores
- [ ] Exchange connectivity tested with conformance/certification suite

## Related Skills

- `confidential_computing` — securing proprietary trading strategies in TEEs
- `zero_knowledge_applications` — private order verification
