require("@nomicfoundation/hardhat-toolbox");
require('hardhat-deploy');
require("dotenv").config();
require('hardhat-gas-reporter');

const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL || 'https://eth-rinkeby/example';
const RINKEBY_PRIVATE_KEY = process.env.RINKEBY_PRIVATE_KEY || '0xkey';
const GANACHE_RPC_URL = process.env.GANACHE_RPC_URL || 'https://eth-rinkeby/example';
const GANACHE_PRIVATE_KEY = process.env.GANACHE_PRIVATE_KEY || '0xkey';
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || 'https://eth-rinkeby/example';
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || '0xkey';

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        rinkeby: {
            url: RINKEBY_RPC_URL,
            accounts: [RINKEBY_PRIVATE_KEY],
            chainId: 4,
            blockConfirmations: 6
        },
        localhost: {
            url: 'http://127.0.0.1:8545/',
            accounts: ['0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80']
        },
        ganache: {
            url: GANACHE_RPC_URL,
            accounts: [GANACHE_PRIVATE_KEY]
        }
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        user: {
            default: 1
        }
    },
    gasReporter: {
        enabled: true,
        outputFile: 'gas-reporter.txt',
        noColors: true,
        currency: 'USD',
        coinmarketcap: COINMARKETCAP_API_KEY,
        token: 'ETH'
    },
    // solidity: "0.8.8"
    solidity: {
        compilers: [
            { version: '0.8.8' },
            { version: '0.6.6' }
        ]
    }
};