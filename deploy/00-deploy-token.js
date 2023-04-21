const { network, ethers } = require("hardhat");
const { developmentChains, networkConfig } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    const token = await deploy("MyToken", {
        from: deployer,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    });
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        console.log("VERIFYING.........");
        await verify(token.address, []);
    }

    console.log("------------------------------------");
};
module.exports.tags = ["all", "MyToken"];
