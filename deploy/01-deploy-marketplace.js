const { network, ethers } = require("hardhat");
const { developmentChains, networkConfig } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    let Token, tokenAddress;

    Token = await ethers.getContract("MyToken");
    tokenAddress = Token.address;
    const args = [tokenAddress];
    const marketplace = await deploy("MarketPlace", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    });

    let token = await ethers.getContract("MyToken");
    const transactionResponse = await token.addMinter(marketplace.address);
    const transactionReciept = await transactionResponse.wait(1);
    console.log(
        `Address: ${transactionReciept.events[0].args.account} got role ${transactionReciept.events[0].args.role}`
    );

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        console.log("VERIFYING.........");
        await verify(marketplace.address, args);
    }

    console.log("------------------------------------");
};
module.exports.tags = ["all", "MarketPlace"];
