---
name: dApp Development
description: Building decentralized applications with React, wagmi, and blockchain integration
---

# dApp Development Skill

**Purpose**: End-to-end workflow for building decentralized application frontends that connect to wallets, read/write blockchain data, and provide excellent user experiences.

---

## 🎯 TRIGGER COMMANDS

```text
"Build a dApp for [use case]"
"Connect wallet to [frontend framework]"
"Blockchain frontend for [contract]"
"Set up wagmi with [chains]"
"Integrate smart contract with React"
"Using dapp_development skill: [task]"
```

---

## 🏗️ Tech Stack Overview

| Layer | Recommended | Alternatives |
|-------|------------|--------------|
| **Framework** | Next.js (App Router) | React + Vite, Remix |
| **Blockchain Library** | wagmi + viem | ethers.js, web3.js |
| **Wallet UI** | RainbowKit / ConnectKit | Custom, thirdweb Connect |
| **Styling** | Tailwind CSS | styled-components, CSS Modules |
| **State** | TanStack Query (via wagmi) | Zustand, Redux |
| **Indexing** | The Graph | Alchemy Subgraphs, custom indexer |
| **Storage** | IPFS (Pinata / web3.storage) | Arweave, Filecoin |

> [!TIP]
> **wagmi + viem** is the current standard for new dApps. It provides type-safe contract interactions, built-in caching via TanStack Query, and excellent TypeScript support. Avoid ethers.js for new projects unless you have a specific reason.

### Project Setup

```bash
# Create Next.js project with wagmi
npx create-wagmi@latest my-dapp
# Or manually:
npx create-next-app@latest my-dapp --typescript --tailwind --app
cd my-dapp
npm install wagmi viem @tanstack/react-query @rainbow-me/rainbowkit
```

---

## 🔗 Wallet Connection

### wagmi Provider Setup

```typescript
// src/config/wagmi.ts
import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { mainnet, polygon, arbitrum, base, sepolia } from "wagmi/chains";

export const config = getDefaultConfig({
  appName: "My dApp",
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID!,
  chains: [mainnet, polygon, arbitrum, base, sepolia],
  ssr: true,
});
```

```typescript
// src/app/providers.tsx
"use client";

import { WagmiProvider } from "wagmi";
import { RainbowKitProvider, darkTheme } from "@rainbow-me/rainbowkit";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { config } from "@/config/wagmi";
import "@rainbow-me/rainbowkit/styles.css";

const queryClient = new QueryClient();

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider theme={darkTheme()}>
          {children}
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
```

```typescript
// src/app/layout.tsx
import { Providers } from "./providers";

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

### Connect Button Component

```typescript
// src/components/ConnectButton.tsx
"use client";

import { ConnectButton as RainbowConnect } from "@rainbow-me/rainbowkit";

export function ConnectButton() {
  return (
    <RainbowConnect
      accountStatus="address"
      chainStatus="icon"
      showBalance={true}
    />
  );
}
```

### Wallet Connector Options

| Connector | Library | Notes |
|-----------|---------|-------|
| **MetaMask** | Built into RainbowKit | Most popular browser wallet |
| **WalletConnect** | `@walletconnect/modal` | Mobile wallets, QR code connection |
| **Coinbase Wallet** | `@coinbase/wallet-sdk` | Coinbase ecosystem |
| **Injected** | Auto-detected | Any browser extension wallet |
| **Safe** | `@safe-global/safe-apps-sdk` | Gnosis Safe multisig |

---

## 📖 Reading Blockchain Data

### Read Contract Data

```typescript
// src/hooks/useTokenBalance.ts
"use client";

import { useReadContract } from "wagmi";
import { formatUnits } from "viem";
import { erc20Abi } from "viem";

const TOKEN_ADDRESS = "0x..." as const;

export function useTokenBalance(userAddress: `0x${string}` | undefined) {
  const { data: balance, isLoading, error } = useReadContract({
    address: TOKEN_ADDRESS,
    abi: erc20Abi,
    functionName: "balanceOf",
    args: userAddress ? [userAddress] : undefined,
    query: {
      enabled: !!userAddress,
      refetchInterval: 10_000, // Refresh every 10s
    },
  });

  return {
    balance: balance ? formatUnits(balance, 18) : "0",
    rawBalance: balance ?? 0n,
    isLoading,
    error,
  };
}
```

### Batch Reads with Multicall

```typescript
import { useReadContracts } from "wagmi";
import { erc20Abi } from "viem";

export function useMultipleTokenBalances(
  userAddress: `0x${string}`,
  tokenAddresses: `0x${string}`[]
) {
  const contracts = tokenAddresses.map((address) => ({
    address,
    abi: erc20Abi,
    functionName: "balanceOf" as const,
    args: [userAddress] as const,
  }));

  const { data, isLoading } = useReadContracts({ contracts });

  return {
    balances: data?.map((result) =>
      result.status === "success" ? result.result : 0n
    ) ?? [],
    isLoading,
  };
}
```

### Watch Events in Real Time

```typescript
import { useWatchContractEvent } from "wagmi";

export function useTransferEvents(tokenAddress: `0x${string}`) {
  useWatchContractEvent({
    address: tokenAddress,
    abi: erc20Abi,
    eventName: "Transfer",
    onLogs(logs) {
      for (const log of logs) {
        console.log("Transfer:", log.args.from, "->", log.args.to, log.args.value);
      }
    },
  });
}
```

---

## ✍️ Writing to the Blockchain

### Send Transaction

```typescript
// src/components/TransferForm.tsx
"use client";

import { useState } from "react";
import { useWriteContract, useWaitForTransactionReceipt } from "wagmi";
import { parseUnits } from "viem";
import { erc20Abi } from "viem";

const TOKEN_ADDRESS = "0x..." as const;

export function TransferForm() {
  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("");

  const {
    writeContract,
    data: hash,
    isPending,
    error: writeError,
  } = useWriteContract();

  const {
    isLoading: isConfirming,
    isSuccess: isConfirmed,
  } = useWaitForTransactionReceipt({ hash });

  async function handleTransfer(e: React.FormEvent) {
    e.preventDefault();
    writeContract({
      address: TOKEN_ADDRESS,
      abi: erc20Abi,
      functionName: "transfer",
      args: [to as `0x${string}`, parseUnits(amount, 18)],
    });
  }

  return (
    <form onSubmit={handleTransfer}>
      <input
        placeholder="Recipient address (0x...)"
        value={to}
        onChange={(e) => setTo(e.target.value)}
      />
      <input
        placeholder="Amount"
        type="number"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <button type="submit" disabled={isPending || isConfirming}>
        {isPending ? "Confirm in wallet..." :
         isConfirming ? "Confirming..." :
         "Transfer"}
      </button>

      {hash && (
        <p>
          Tx: <a href={`https://etherscan.io/tx/${hash}`} target="_blank">
            {hash.slice(0, 10)}...
          </a>
        </p>
      )}
      {isConfirmed && <p>Transaction confirmed!</p>}
      {writeError && <p>Error: {writeError.message}</p>}
    </form>
  );
}
```

### Transaction Lifecycle

```text
User clicks "Transfer"
  → writeContract() called
  → Wallet popup appears (MetaMask, etc.)
  → User confirms in wallet
    → isPending = true (waiting for wallet)
  → Transaction submitted to mempool
    → hash returned
    → isConfirming = true (waiting for block)
  → Transaction mined in block
    → isConfirmed = true
  → UI updates with success
```

### Approve + Transfer Pattern (ERC-20)

```typescript
import { useWriteContract, useReadContract } from "wagmi";
import { erc20Abi, maxUint256 } from "viem";

export function useApproveAndStake(tokenAddress: `0x${string}`, spender: `0x${string}`) {
  const { writeContract: approve } = useWriteContract();
  const { writeContract: stake } = useWriteContract();

  // Check current allowance
  const { data: allowance } = useReadContract({
    address: tokenAddress,
    abi: erc20Abi,
    functionName: "allowance",
    args: [userAddress, spender],
  });

  async function approveAndStake(amount: bigint) {
    // Step 1: Approve if needed
    if (!allowance || allowance < amount) {
      approve({
        address: tokenAddress,
        abi: erc20Abi,
        functionName: "approve",
        args: [spender, maxUint256], // or exact amount
      });
      // Wait for approval tx to confirm before staking...
    }

    // Step 2: Stake
    stake({
      address: spender,
      abi: stakingAbi,
      functionName: "stake",
      args: [amount],
    });
  }

  return { approveAndStake };
}
```

---

## 🔐 Authentication: Sign-In with Ethereum (SIWE)

```typescript
// src/hooks/useSIWE.ts
import { useSignMessage, useAccount } from "wagmi";
import { SiweMessage } from "siwe";

export function useSIWE() {
  const { address, chain } = useAccount();
  const { signMessageAsync } = useSignMessage();

  async function signIn() {
    if (!address || !chain) throw new Error("Wallet not connected");

    // 1. Get nonce from your backend
    const nonceRes = await fetch("/api/auth/nonce");
    const { nonce } = await nonceRes.json();

    // 2. Create SIWE message
    const message = new SiweMessage({
      domain: window.location.host,
      address,
      statement: "Sign in to My dApp",
      uri: window.location.origin,
      version: "1",
      chainId: chain.id,
      nonce,
    });

    // 3. Sign the message
    const signature = await signMessageAsync({
      message: message.prepareMessage(),
    });

    // 4. Verify on backend
    const verifyRes = await fetch("/api/auth/verify", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: message.toMessage(), signature }),
    });

    return verifyRes.json();
  }

  return { signIn, address };
}
```

---

## 📊 The Graph: Indexed Data

### Subgraph Schema

```graphql
# schema.graphql
type Transfer @entity {
  id: Bytes!
  from: Bytes!
  to: Bytes!
  value: BigInt!
  blockNumber: BigInt!
  blockTimestamp: BigInt!
  transactionHash: Bytes!
}

type TokenHolder @entity {
  id: Bytes! # address
  balance: BigInt!
  transferCount: BigInt!
}
```

### Event Handler

```typescript
// src/mapping.ts
import { Transfer as TransferEvent } from "../generated/MyToken/MyToken";
import { Transfer, TokenHolder } from "../generated/schema";
import { BigInt, Bytes } from "@graphprotocol/graph-ts";

export function handleTransfer(event: TransferEvent): void {
  // Create Transfer entity
  let transfer = new Transfer(event.transaction.hash.concatI32(event.logIndex.toI32()));
  transfer.from = event.params.from;
  transfer.to = event.params.to;
  transfer.value = event.params.value;
  transfer.blockNumber = event.block.number;
  transfer.blockTimestamp = event.block.timestamp;
  transfer.transactionHash = event.transaction.hash;
  transfer.save();

  // Update holder balances
  let fromHolder = TokenHolder.load(event.params.from);
  if (fromHolder) {
    fromHolder.balance = fromHolder.balance.minus(event.params.value);
    fromHolder.transferCount = fromHolder.transferCount.plus(BigInt.fromI32(1));
    fromHolder.save();
  }
}
```

### Query from Frontend

```typescript
const TRANSFERS_QUERY = `
  query GetRecentTransfers($first: Int!) {
    transfers(first: $first, orderBy: blockTimestamp, orderDirection: desc) {
      id
      from
      to
      value
      blockTimestamp
      transactionHash
    }
  }
`;

async function fetchTransfers() {
  const response = await fetch(SUBGRAPH_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      query: TRANSFERS_QUERY,
      variables: { first: 20 },
    }),
  });
  const { data } = await response.json();
  return data.transfers;
}
```

---

## 🗄️ IPFS / Decentralized Storage

### Upload Metadata (Pinata)

```typescript
import PinataClient from "@pinata/sdk";

const pinata = new PinataClient({
  pinataApiKey: process.env.PINATA_API_KEY!,
  pinataSecretApiKey: process.env.PINATA_SECRET_KEY!,
});

// ERC-721 metadata standard
async function uploadNFTMetadata(name: string, description: string, imageFile: File) {
  // 1. Upload image
  const imageResult = await pinata.pinFileToIPFS(imageFile);
  const imageURI = `ipfs://${imageResult.IpfsHash}`;

  // 2. Upload metadata JSON
  const metadata = {
    name,
    description,
    image: imageURI,
    attributes: [
      { trait_type: "Rarity", value: "Legendary" },
      { trait_type: "Power", value: 95 },
    ],
  };

  const metadataResult = await pinata.pinJSONToIPFS(metadata);
  return `ipfs://${metadataResult.IpfsHash}`;
}
```

---

## 🧩 Common UX Patterns

| Pattern | Implementation |
|---------|---------------|
| **Pending transaction** | Show spinner + "Confirming..." after wallet confirmation |
| **Transaction history** | Store tx hashes in localStorage, show status |
| **Block explorer link** | `https://etherscan.io/tx/${hash}` -- open in new tab |
| **ENS resolution** | `useEnsName({ address })` / `useEnsAddress({ name })` |
| **Chain switching** | `useSwitchChain()` hook with dropdown |
| **Network mismatch** | Warn user + auto-prompt to switch chain |
| **Wallet disconnection** | Clear session state, show connect button |

---

## ❌ Error Handling

| Error | Cause | User Message |
|-------|-------|-------------|
| `UserRejectedRequestError` | User clicked "Reject" in wallet | "Transaction cancelled" |
| `InsufficientFundsError` | Not enough ETH/token for gas + value | "Insufficient funds for this transaction" |
| `ContractFunctionRevertedError` | Contract `require`/`revert` failed | Parse revert reason, show to user |
| `ChainMismatchError` | Connected to wrong chain | "Please switch to [network name]" |
| RPC timeout | Provider issue | "Network congestion, please try again" |

```typescript
import {
  UserRejectedRequestError,
  ContractFunctionRevertedError,
} from "viem";

function getErrorMessage(error: Error): string {
  if (error instanceof UserRejectedRequestError) {
    return "Transaction cancelled by user.";
  }
  if (error instanceof ContractFunctionRevertedError) {
    return `Transaction failed: ${error.reason ?? "Unknown contract error"}`;
  }
  if (error.message.includes("insufficient funds")) {
    return "Insufficient funds for this transaction.";
  }
  return "An unexpected error occurred. Please try again.";
}
```

---

## 🔗 Multi-Chain Support

```typescript
// src/config/contracts.ts
import { mainnet, polygon, arbitrum, base } from "wagmi/chains";

export const CONTRACT_ADDRESSES: Record<number, `0x${string}`> = {
  [mainnet.id]: "0x1111111111111111111111111111111111111111",
  [polygon.id]: "0x2222222222222222222222222222222222222222",
  [arbitrum.id]: "0x3333333333333333333333333333333333333333",
  [base.id]: "0x4444444444444444444444444444444444444444",
};

export function getContractAddress(chainId: number): `0x${string}` {
  const address = CONTRACT_ADDRESSES[chainId];
  if (!address) throw new Error(`Contract not deployed on chain ${chainId}`);
  return address;
}
```

> [!WARNING]
> When supporting multiple chains, ensure your contract ABI is identical across all deployments. Different ABIs per chain will cause silent failures and confusing errors.

---

## 🧪 Testing dApps

```typescript
// Use Hardhat node for local testing
// In terminal 1:
// npx hardhat node

// In terminal 2:
// Configure wagmi with localhost chain
import { hardhat } from "wagmi/chains";

// Add hardhat to your chain config for dev
const devChains = [hardhat, sepolia, mainnet];

// Fork mainnet for realistic testing
// npx hardhat node --fork https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY
```

> [!TIP]
> Use `hardhat node --fork` to test against real mainnet state (token balances, liquidity pools) without spending real ETH. This catches issues that local-only testing misses.

---

## ✅ EXIT CHECKLIST

- [ ] Wallet connects successfully on all target chains
- [ ] Chain switching works with proper prompts
- [ ] Contract reads display correct on-chain data
- [ ] Contract writes succeed with proper pending/confirmed states
- [ ] Transaction errors handled gracefully with user-friendly messages
- [ ] SIWE authentication flow works end-to-end (if applicable)
- [ ] IPFS metadata uploaded and pinned (if applicable)
- [ ] The Graph subgraph deployed and queried (if applicable)
- [ ] ENS names resolved where applicable
- [ ] Mobile wallet connection tested (WalletConnect)
- [ ] Multi-chain contract addresses configured
- [ ] Block explorer links included for all transactions
- [ ] Loading states shown during blockchain reads/writes
- [ ] Tested against forked mainnet for realistic behavior

---

*Skill Version: 1.0 | Created: February 2026*
