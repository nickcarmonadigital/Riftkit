---
name: Web3 Security
description: Smart contract security auditing, vulnerability detection, and audit reporting
---

# Web3 Security Skill

**Purpose**: Systematic workflow for auditing smart contracts, identifying vulnerabilities, running automated tools, and producing professional audit reports.

---

## 🎯 TRIGGER COMMANDS

```text
"Audit this smart contract: [paste code or repo]"
"Web3 security check on [contract name]"
"Find vulnerabilities in [contract]"
"Run a security audit for [protocol]"
"Check for reentrancy in [contract]"
"Using web3_security skill: [audit task]"
```

---

## ⚠️ Why Smart Contract Security Is Different

| Traditional Software | Smart Contracts |
|---------------------|-----------------|
| Can patch bugs post-release | **Immutable** once deployed (no hotfixes) |
| Handles user data | **Handles real money** (TVL can be billions) |
| Isolated attack surface | **Composable** attack surface (any contract can call yours) |
| Users trust the company | **Users trust the code** (trustless by design) |
| Gradual rollout possible | **All-or-nothing** deployment |
| Downtime = inconvenience | **Exploit = permanent fund loss** |

> [!WARNING]
> A single missed vulnerability can drain an entire protocol. Smart contract auditing requires significantly more rigor than traditional code review. There are no second chances.

---

## 🔧 Audit Tools Comparison

| Tool | Method | Cost | Speed | Best For |
|------|--------|------|-------|----------|
| **Slither** | Static analysis | Free | Fast (seconds) | First-pass vulnerability scanning |
| **Mythril** | Symbolic execution | Free | Slow (minutes) | Deep logic bugs, path exploration |
| **Echidna** | Property-based fuzzing | Free | Medium | Invariant testing, edge cases |
| **Foundry Fuzz** | Fuzz testing | Free | Fast | Inline fuzz tests with forge |
| **Certora** | Formal verification | Paid ($$$) | Slow | Mathematical correctness proofs |
| **Aderyn** | Static analysis (Rust) | Free | Very fast | Fast scanning, modern codebase |
| **4naly3er** | Static analysis | Free | Fast | Gas optimizations + low findings |

### Running Slither

```bash
# Installation
pip install slither-analyzer

# Basic scan
slither . --filter-paths "node_modules|lib"

# Target specific contract
slither src/MyContract.sol --filter-paths "node_modules"

# Print specific detector results
slither . --detect reentrancy-eth,reentrancy-no-eth,suicidal

# Generate human-readable summary
slither . --print human-summary

# Export to JSON for CI integration
slither . --json output.json
```

> [!TIP]
> Slither outputs findings by severity (High, Medium, Low, Informational). Focus on High/Medium first. Many Low/Informational findings are false positives -- verify each manually.

---

## 🚨 Vulnerability Categories by Severity

### Critical Severity

| Vulnerability | Description | Detection |
|---------------|-------------|-----------|
| **Reentrancy** | Attacker re-enters function before state updates | Slither `reentrancy-eth`, manual CEI check |
| **Delegatecall injection** | Attacker controls target of `delegatecall` | Manual review of proxy patterns |
| **Unprotected initializers** | `initialize()` callable by anyone post-deploy | Check `initializer` modifier on all init functions |
| **Storage collision (proxies)** | Proxy and implementation share storage slots | Verify EIP-1967 storage slots, use OpenZeppelin |
| **Arbitrary external calls** | User-controlled address in `.call()` | Manual review, Slither `arbitrary-send-eth` |

### High Severity

| Vulnerability | Description | Detection |
|---------------|-------------|-----------|
| **Missing access control** | Privileged functions callable by anyone | Slither `missing-access-control`, manual review |
| **Oracle manipulation** | Attacker manipulates price feed in single tx | Review oracle source, check for flash loan resistance |
| **Flash loan attacks** | Borrow → manipulate → profit → repay in one tx | Analyze token balance assumptions |
| **Signature replay** | Reuse of signed messages across chains/contracts | Check nonce and chainId in EIP-712 signatures |
| **Front-running / MEV** | Miners/searchers extract value from pending txs | Commit-reveal patterns, private mempools |

### Medium Severity

| Vulnerability | Description | Detection |
|---------------|-------------|-----------|
| **Centralization risk** | Owner can rug (upgrade, pause, drain) | Review admin functions, timelocks, multisig |
| **Missing events** | State changes without logs | Slither `missing-events-access-control` |
| **Gas griefing** | Attacker makes function consume excessive gas | Review loops with external input |
| **Denial of service** | Contract permanently stuck | Check for unbounded loops, push vs pull patterns |
| **Unsafe casting** | Truncation when casting between types | Manual review, Slither `unsafe-cast` |

### Low Severity

| Vulnerability | Description | Detection |
|---------------|-------------|-----------|
| **Floating pragma** | `pragma solidity ^0.8.0` instead of locked | Slither `pragma` detector |
| **Missing zero-address checks** | Functions accept `address(0)` | Manual review of constructors and setters |
| **Unused variables** | Dead code, potential logic error | Slither `unused-variables` |
| **Inconsistent naming** | Breaks conventions, confuses auditors | Slither `naming-convention` |

---

## 📋 Audit Process

### Step 1: Understand the Protocol

```text
[ ] Read all documentation (whitepaper, README, specs)
[ ] Understand the business logic and user flows
[ ] Map the architecture (contracts, inheritance, interactions)
[ ] Identify trust boundaries (who can call what)
[ ] Review existing tests and coverage
[ ] Note external dependencies (oracles, other protocols)
```

### Step 2: Automated Scanning

```bash
# Run Slither
slither . --filter-paths "node_modules|lib" 2>&1 | tee slither-report.txt

# Run Mythril (on specific contract)
myth analyze src/MyContract.sol --solc-json mythril.config.json

# Run Aderyn
aderyn . --output aderyn-report.md
```

### Step 3: Manual Review (Line by Line)

```text
[ ] Read every function, understand its purpose
[ ] Trace all external calls (potential reentrancy)
[ ] Verify access control on every state-changing function
[ ] Check all math operations (especially division, rounding)
[ ] Review upgrade logic and storage layout
[ ] Verify event emissions for all state changes
[ ] Check for hardcoded addresses or magic numbers
```

### Step 4: Write Findings Report

### Step 5: Verify Fixes (Re-audit)

---

## 🔁 Reentrancy Deep Dive

Reentrancy is the most exploited vulnerability in DeFi history (DAO hack, Curve exploit, etc.).

### Types of Reentrancy

| Type | Description | Example |
|------|-------------|---------|
| **Single-function** | Re-enter the same function | `withdraw()` calls external contract before updating balance |
| **Cross-function** | Re-enter a different function | `withdraw()` → attacker calls `transfer()` using stale balance |
| **Cross-contract** | Re-enter via a different contract | Contract A calls Contract B which calls back into A |
| **Read-only** | Re-enter a view function during state change | Oracle reads stale state during a callback |

### The CEI Pattern (Checks-Effects-Interactions)

```solidity
// BAD: Interactions before Effects (vulnerable)
function withdraw(uint256 amount) external {
    require(balances[msg.sender] >= amount);      // Check
    (bool success, ) = msg.sender.call{value: amount}(""); // Interaction FIRST
    require(success);
    balances[msg.sender] -= amount;                // Effect AFTER (too late!)
}

// GOOD: CEI Pattern (safe)
function withdraw(uint256 amount) external nonReentrant {
    require(balances[msg.sender] >= amount);      // 1. Check
    balances[msg.sender] -= amount;                // 2. Effect (update state)
    (bool success, ) = msg.sender.call{value: amount}(""); // 3. Interaction
    require(success);
}
```

> [!WARNING]
> Always apply the CEI pattern AND use `ReentrancyGuard`. Defense in depth -- never rely on a single mitigation.

---

## 🏦 DeFi-Specific Risks

### Flash Loan Attack Pattern

```text
1. Borrow massive amount (flash loan, zero collateral)
2. Manipulate price/state using borrowed funds
3. Exploit protocol using manipulated state
4. Repay flash loan + fee
5. Keep profit
```

### Oracle Security

| Oracle Type | Risk Level | Notes |
|-------------|-----------|-------|
| **Chainlink** | Low | Decentralized, manipulation-resistant |
| **Uniswap TWAP** | Medium | Requires sufficient time window (30min+) |
| **Spot price** | Critical | Trivially manipulated with flash loans |
| **Custom oracle** | High | Single point of failure |

> [!TIP]
> Always use Chainlink price feeds for production DeFi. If using TWAP, ensure the time window is at least 30 minutes. **Never** use spot prices from a single DEX.

---

## 🧪 Fuzz Testing

### Foundry Invariant Testing

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultInvariantTest is Test {
    Vault vault;

    function setUp() public {
        vault = new Vault();
        // Fund the test contract
        deal(address(this), 100 ether);
    }

    // This function is called with random inputs by the fuzzer
    function invariant_totalSharesMatchDeposits() public view {
        // The vault should never have more shares than deposits
        assertGe(
            address(vault).balance,
            vault.totalShares(),
            "Vault is undercollateralized"
        );
    }

    function invariant_noFreeWithdrawals() public view {
        // Users with 0 shares should have 0 claimable
        assertEq(vault.claimable(address(0xdead)), 0);
    }
}
```

### Echidna Property Testing

```solidity
contract MyTokenEchidna is MyToken {
    // Echidna looks for functions prefixed with echidna_
    function echidna_totalSupply_never_exceeds_max() public view returns (bool) {
        return totalSupply() <= MAX_SUPPLY;
    }

    function echidna_balance_never_negative() public view returns (bool) {
        return balanceOf(msg.sender) >= 0; // Always true for uint, but tests logic
    }
}
```

```bash
# Run Echidna
echidna . --contract MyTokenEchidna --config echidna.yaml
```

---

## 📄 Audit Report Structure

```markdown
# Security Audit Report: [Protocol Name]

## Executive Summary
- **Audit Date**: [date range]
- **Commit Hash**: [git hash]
- **Scope**: [list of contracts audited]
- **Findings**: X Critical, Y High, Z Medium, W Low

## Methodology
- Automated tools: Slither, Mythril, Foundry fuzz
- Manual review: Line-by-line code analysis
- Test coverage analysis

## Findings

### [C-01] Critical: Reentrancy in withdraw()
- **Severity**: Critical
- **Status**: Fixed / Acknowledged / Disputed
- **File**: src/Vault.sol:L142
- **Description**: The withdraw function sends ETH before updating state...
- **Recommendation**: Apply CEI pattern and add ReentrancyGuard
- **Developer Response**: Fixed in commit abc123

### [H-01] High: Missing access control on setOracle()
...

## Gas Optimizations
| ID | Description | Estimated Savings |
|----|-------------|-------------------|
| G-01 | Use custom errors | ~200 gas per revert |

## Appendix
- Full Slither output
- Test coverage report
- Dependency analysis
```

---

## 🛡️ Post-Audit Security

| Activity | Tool | Purpose |
|----------|------|---------|
| **Bug bounty** | Immunefi, HackerOne | Continuous vulnerability discovery |
| **Monitoring** | Forta, OpenZeppelin Defender | Real-time exploit detection |
| **Incident response** | Documented runbook | Pause contract, communicate, migrate |
| **Timelock** | OpenZeppelin TimelockController | Delay admin actions (24-48h) |
| **Multisig** | Safe (Gnosis Safe) | Require multiple signers for admin ops |

> [!TIP]
> Bug bounties on Immunefi typically pay 10% of funds at risk, up to millions of dollars. A $500K TVL protocol should offer at least a $50K bounty.

---

## ✅ EXIT CHECKLIST

- [ ] Slither scan shows 0 high/critical findings
- [ ] Mythril scan completed with no critical paths
- [ ] Manual line-by-line review complete for all in-scope contracts
- [ ] Fuzz tests pass for all invariants (Foundry/Echidna)
- [ ] Reentrancy guards on all functions that transfer value
- [ ] CEI pattern applied to all external calls
- [ ] Access control verified on every state-changing function
- [ ] Oracle manipulation resistance confirmed
- [ ] Flash loan attack scenarios tested
- [ ] Upgrade/proxy storage layout verified (if applicable)
- [ ] Centralization risks documented with mitigations (timelock, multisig)
- [ ] Audit report written with all findings categorized by severity
- [ ] Bug bounty program configured (Immunefi)
- [ ] Monitoring configured (Forta/Defender)

---

*Skill Version: 1.0 | Created: February 2026*
