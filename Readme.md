# Marketplace Contract to sell erc20 tokens

## Description

This contract is used to create a marketplace and sell the erc20 token.

## Technologies Used

-   [hardhat](https://hardhat.org/docs)

## Quick Start

-   create .env file with SEPOLA_RPC_URL, PRIVATE_KEY, ETHERSCAN_API_KEY, COIN_MARKET_CAP_API_KEY

-   Install all dependencies

    `yarn install`

-   Compile contract

    `yarn compile`

-   Deploy contract
    `yarn hardhat deploy --network sepolia`

## Features

-   ERC20 token with total supply of 21 million tokens
-   Marketplace contract with price for each token as 0.01 ETH
-   Token can be claimed after 365 days of buying only
