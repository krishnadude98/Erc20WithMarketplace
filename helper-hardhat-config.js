const { ethers } = require("hardhat");
const networkConfig = {
    11155111: {
        name: "sepolia",
        entranceFee: ethers.utils.parseEther("0.05"),
        interval: "30",
    },
    31337: {
        name: "hardhat",
        entranceFee: ethers.utils.parseEther("0.05"),
        interval: "30",
    },
};

const developmentChains = ["hardhat", "localhost"];

module.exports = {
    networkConfig,
    developmentChains,
};
