/**
 * EVM Configuration for RapidDAO
 * 
 * To build for different chains, set the VITE_CHAIN environment variable:
 * VITE_CHAIN=devnet pnpm run build    (for local development - default)
 */

import metadata from '../metadata.json';

const targetChainName = import.meta.env.VITE_CHAIN || 'base';

// Find the chain configuration by network name
const evmConfig = metadata.chains.find(chain => chain.network === targetChainName);

if (!evmConfig) {
  throw new Error(`Chain '${targetChainName}' not found in metadata.json`);
}

// Get the RapidDAO contract
const contractInfo = evmConfig.contracts[0];

export const selectedChain = evmConfig;
export const contractAddress = contractInfo.address;
export const contractABI = contractInfo.abi;
export const chainId = parseInt(evmConfig.chainId);
export const rpcUrl = evmConfig.rpc_url;
export const networkName = evmConfig.network;
