---
name: Smart Contract Development
description: Blockchain smart contract development with Solidity, testing, and deployment workflows
---

# Smart Contract Development Skill

**Purpose**: Structured workflow for building, testing, optimizing, and deploying smart contracts on EVM-compatible blockchains.

---

## 🎯 TRIGGER COMMANDS

```text
"Build a smart contract for [use case]"
"Solidity development for [feature]"
"Deploy contract to [network]"
"Create an ERC-20 / ERC-721 / ERC-1155 token"
"Set up Hardhat / Foundry project"
"Using smart_contract_dev skill: [task]"
```

---

## 🛠️ Development Framework Comparison

| Framework | Language | Speed | Debugging | Best For |
|-----------|----------|-------|-----------|----------|
| **Hardhat** | JS/TS | Medium | Excellent (stack traces, console.log) | Most projects, beginners |
| **Foundry** | Solidity | Fastest | Good (traces, -vvvv) | Advanced devs, fuzz testing |
| **Truffle** | JS | Slow | Basic | Legacy projects (being sunset) |
| **Brownie** | Python | Medium | Good | Python-native teams |

> [!TIP]
> **Recommendation**: Use **Hardhat** for full-stack dApp projects (better JS/TS integration). Use **Foundry** for pure smart contract work (fastest tests, Solidity-native testing).

### Project Initialization

```bash
# Hardhat
mkdir my-contract && cd my-contract
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npx hardhat init  # Choose TypeScript project

# Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge init my-contract
```

---

## 📝 Solidity Fundamentals

### Contract Structure

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title MyContract
/// @notice A description of what this contract does
/// @dev Implementation details for developers
contract MyContract is Ownable {
    // --- State Variables ---
    uint256 public totalSupply;
    mapping(address => uint256) private _balances;

    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // --- Custom Errors (gas efficient) ---
    error InsufficientBalance(uint256 requested, uint256 available);
    error ZeroAddress();

    // --- Modifiers ---
    modifier notZeroAddress(address addr) {
        if (addr == address(0)) revert ZeroAddress();
        _;
    }

    // --- Constructor ---
    constructor() Ownable(msg.sender) {
        totalSupply = 1_000_000 * 1e18;
        _balances[msg.sender] = totalSupply;
    }

    // --- External Functions ---
    /// @notice Transfer tokens to another address
    /// @param to Recipient address
    /// @param amount Amount in wei
    function transfer(address to, uint256 amount) external notZeroAddress(to) {
        if (_balances[msg.sender] < amount) {
            revert InsufficientBalance(amount, _balances[msg.sender]);
        }
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    // --- View Functions (read-only, no gas when called externally) ---
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    // --- Pure Functions (no state access) ---
    function calculateFee(uint256 amount) external pure returns (uint256) {
        return (amount * 3) / 100; // 3% fee
    }

    // --- Payable Functions (receives ETH) ---
    function deposit() external payable {
        _balances[msg.sender] += msg.value;
    }
}
```

### Function Visibility

| Visibility | Contract | Derived | External | Cost |
|------------|----------|---------|----------|------|
| `public` | Yes | Yes | Yes | Higher (copies calldata to memory) |
| `external` | No | No | Yes | Lower (reads calldata directly) |
| `internal` | Yes | Yes | No | N/A (inlined) |
| `private` | Yes | No | No | N/A (inlined) |

---

## 🏗️ Common Contract Patterns

### OpenZeppelin Building Blocks

| Pattern | Import | Purpose |
|---------|--------|---------|
| `Ownable` | `@openzeppelin/contracts/access/Ownable.sol` | Single-owner access control |
| `AccessControl` | `@openzeppelin/contracts/access/AccessControl.sol` | Role-based permissions |
| `Pausable` | `@openzeppelin/contracts/utils/Pausable.sol` | Emergency stop mechanism |
| `ReentrancyGuard` | `@openzeppelin/contracts/utils/ReentrancyGuard.sol` | Reentrancy protection |

### Token Standards

| Standard | Type | Use Case |
|----------|------|----------|
| **ERC-20** | Fungible token | Currencies, utility tokens, governance tokens |
| **ERC-721** | Non-fungible token (NFT) | Unique assets, collectibles, deeds |
| **ERC-1155** | Multi-token | Gaming items (mix of fungible + non-fungible) |
| **ERC-4626** | Tokenized vault | Yield aggregators, staking pools |

### ERC-20 Token Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, ERC20Permit, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000 * 1e18; // 100M tokens

    constructor()
        ERC20("MyToken", "MTK")
        ERC20Permit("MyToken")
        Ownable(msg.sender)
    {
        _mint(msg.sender, 10_000_000 * 1e18); // Pre-mint 10M
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
    }
}
```

---

## 🧪 Testing Smart Contracts

### Hardhat Test Example (TypeScript)

```typescript
import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";

describe("MyToken", function () {
  async function deployFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const MyToken = await ethers.getContractFactory("MyToken");
    const token = await MyToken.deploy();
    return { token, owner, addr1, addr2 };
  }

  describe("Deployment", function () {
    it("should set the correct name and symbol", async function () {
      const { token } = await loadFixture(deployFixture);
      expect(await token.name()).to.equal("MyToken");
      expect(await token.symbol()).to.equal("MTK");
    });

    it("should mint initial supply to owner", async function () {
      const { token, owner } = await loadFixture(deployFixture);
      const balance = await token.balanceOf(owner.address);
      expect(balance).to.equal(ethers.parseEther("10000000"));
    });
  });

  describe("Transfers", function () {
    it("should transfer tokens between accounts", async function () {
      const { token, owner, addr1 } = await loadFixture(deployFixture);
      const amount = ethers.parseEther("1000");

      await token.transfer(addr1.address, amount);
      expect(await token.balanceOf(addr1.address)).to.equal(amount);
    });

    it("should revert on insufficient balance", async function () {
      const { token, addr1, addr2 } = await loadFixture(deployFixture);
      await expect(
        token.connect(addr1).transfer(addr2.address, 1)
      ).to.be.revertedWithCustomError(token, "ERC20InsufficientBalance");
    });
  });

  describe("Minting", function () {
    it("should not exceed max supply", async function () {
      const { token, owner } = await loadFixture(deployFixture);
      const maxSupply = ethers.parseEther("100000000");
      const currentSupply = await token.totalSupply();
      const excess = maxSupply - currentSupply + 1n;

      await expect(
        token.mint(owner.address, excess)
      ).to.be.revertedWith("Exceeds max supply");
    });
  });
});
```

### Foundry Test Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken token;
    address owner = address(this);
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        token = new MyToken();
    }

    function test_InitialSupply() public view {
        assertEq(token.totalSupply(), 10_000_000 * 1e18);
    }

    function test_Transfer() public {
        token.transfer(alice, 1000e18);
        assertEq(token.balanceOf(alice), 1000e18);
    }

    // Fuzz test: any amount up to balance should succeed
    function testFuzz_Transfer(uint256 amount) public {
        amount = bound(amount, 0, token.balanceOf(owner));
        token.transfer(alice, amount);
        assertEq(token.balanceOf(alice), amount);
    }

    function test_RevertWhen_TransferExceedsBalance() public {
        vm.prank(alice);
        vm.expectRevert();
        token.transfer(bob, 1);
    }
}
```

> [!TIP]
> Run Foundry tests with `forge test -vvvv` for full stack traces. Use `forge test --gas-report` for gas consumption analysis.

---

## ⛽ Gas Optimization

| Technique | Savings | Example |
|-----------|---------|---------|
| **Storage packing** | ~20k gas per slot | Pack `uint128 + uint128` into one slot instead of two `uint256` |
| **`calldata` over `memory`** | ~600 gas per param | Use `calldata` for read-only external function parameters |
| **`unchecked` blocks** | ~100-200 gas per op | Wrap arithmetic that cannot overflow (e.g., loop counters) |
| **`immutable` / `constant`** | ~2100 gas per read | Use for values set once at deploy or compile time |
| **Custom errors** | ~200 gas vs `require` strings | `error InsufficientBalance()` instead of `require(x, "message")` |
| **Events over storage** | ~20k gas saved | Log data you only need off-chain instead of storing it |
| **Batch operations** | Amortized overhead | Batch mints/transfers in a single transaction |

```solidity
// BAD: Wastes storage slots
uint256 public startTime;   // Slot 0 (32 bytes, wastes 24 bytes)
uint8 public status;         // Slot 1 (wastes 31 bytes)
uint256 public endTime;      // Slot 2

// GOOD: Packed into 2 slots
uint256 public startTime;   // Slot 0
uint256 public endTime;      // Slot 1
uint8 public status;         // Slot 2 (or pack with next var)

// GOOD: calldata for read-only params
function processData(bytes calldata data) external pure returns (bytes32) {
    return keccak256(data);
}

// GOOD: unchecked where overflow is impossible
function sum(uint256[] calldata values) external pure returns (uint256 total) {
    for (uint256 i; i < values.length;) {
        total += values[i];
        unchecked { ++i; } // i cannot overflow with realistic array sizes
    }
}
```

---

## 🚀 Deployment

### Hardhat Deployment Script

```typescript
import { ethers, run } from "hardhat";

async function main() {
  console.log("Deploying MyToken...");

  const MyToken = await ethers.getContractFactory("MyToken");
  const token = await MyToken.deploy();
  await token.waitForDeployment();

  const address = await token.getAddress();
  console.log(`MyToken deployed to: ${address}`);

  // Wait for block confirmations before verifying
  console.log("Waiting for 5 block confirmations...");
  await token.deploymentTransaction()?.wait(5);

  // Verify on Etherscan
  console.log("Verifying on Etherscan...");
  await run("verify:verify", {
    address: address,
    constructorArguments: [],
  });

  console.log("Deployment and verification complete!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

### Hardhat Configuration (Multi-Network)

```typescript
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const DEPLOYER_KEY = process.env.DEPLOYER_PRIVATE_KEY || "";
const ETHERSCAN_KEY = process.env.ETHERSCAN_API_KEY || "";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: { enabled: true, runs: 200 },
      viaIR: true,
    },
  },
  networks: {
    hardhat: {
      forking: {
        url: process.env.MAINNET_RPC_URL || "",
        enabled: !!process.env.FORK_MAINNET,
      },
    },
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL || "",
      accounts: DEPLOYER_KEY ? [DEPLOYER_KEY] : [],
    },
    polygon_amoy: {
      url: process.env.AMOY_RPC_URL || "",
      accounts: DEPLOYER_KEY ? [DEPLOYER_KEY] : [],
    },
    mainnet: {
      url: process.env.MAINNET_RPC_URL || "",
      accounts: DEPLOYER_KEY ? [DEPLOYER_KEY] : [],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_KEY,
  },
};

export default config;
```

### Deployment Targets

| Network | Type | Gas Cost | Use |
|---------|------|----------|-----|
| **Hardhat Node / Anvil** | Local | Free | Development & unit testing |
| **Sepolia** | Ethereum testnet | Free (faucet ETH) | Integration testing |
| **Amoy** | Polygon testnet | Free (faucet MATIC) | L2 testing |
| **Fuji** | Avalanche testnet | Free (faucet AVAX) | Avalanche testing |
| **Ethereum Mainnet** | Production | Real ETH | Production deployment |
| **Polygon / Arbitrum / Base** | L2 Production | Lower fees | Cost-efficient production |

> [!WARNING]
> **NEVER commit `.env` files containing private keys.** Add `.env` to `.gitignore` immediately. Use a separate deployer wallet with only the funds needed for deployment.

---

## 🔄 Upgrade Patterns

| Pattern | Complexity | Storage Safety | Best For |
|---------|-----------|----------------|----------|
| **Transparent Proxy** | Medium | Manual management | Standard upgradeable contracts |
| **UUPS Proxy** | Medium | Manual management | Gas-efficient upgrades (logic in impl) |
| **Diamond (EIP-2535)** | High | Automatic via facets | Large contracts exceeding 24KB limit |
| **Beacon Proxy** | Medium | Shared logic | Many instances sharing same logic |

> [!WARNING]
> Upgradeable contracts cannot use constructors. Use `initialize()` functions with `initializer` modifier. Always declare storage variables in the same order across upgrades -- never reorder or remove them.

---

## 🛡️ Common Vulnerabilities

| Vulnerability | Severity | Mitigation |
|---------------|----------|------------|
| **Reentrancy** | Critical | `ReentrancyGuard`, CEI pattern (Checks-Effects-Interactions) |
| **Integer overflow** | Critical (pre-0.8) | Use Solidity >= 0.8 (built-in checks) |
| **Front-running / MEV** | High | Commit-reveal schemes, Flashbots Protect |
| **Oracle manipulation** | High | Chainlink oracles, TWAP with sufficient window |
| **Access control** | High | OpenZeppelin `Ownable` / `AccessControl` |
| **Selfdestruct** | High | Avoid in upgradeable contracts; deprecated in newer versions |
| **Unchecked return values** | Medium | Always check `transfer()` return value or use `SafeERC20` |
| **Timestamp dependence** | Low | Avoid using `block.timestamp` for critical logic |

---

## ✅ Contract Verification

```bash
# Hardhat
npx hardhat verify --network sepolia <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>

# Foundry
forge verify-contract <CONTRACT_ADDRESS> src/MyToken.sol:MyToken \
  --chain sepolia \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

> [!TIP]
> Verified contracts show source code on Etherscan, allowing users to read and trust the code. Always verify immediately after deployment.

---

## ✅ EXIT CHECKLIST

- [ ] All unit tests pass (`npx hardhat test` / `forge test`)
- [ ] Gas report reviewed and optimized (`forge test --gas-report`)
- [ ] No Slither high/critical findings (`slither .`)
- [ ] Reentrancy guards on all external calls that transfer value
- [ ] Access control on privileged functions
- [ ] Events emitted for all state changes
- [ ] Custom errors used instead of require strings
- [ ] Deployed to testnet and manually verified
- [ ] Contract verified on block explorer (Etherscan/Polygonscan)
- [ ] `.env` with private keys is in `.gitignore`
- [ ] Mainnet deployment plan documented (gas budget, multisig setup)
- [ ] Upgrade path defined (if upgradeable)

---

*Skill Version: 1.0 | Created: February 2026*
