const { developmentChains, networkConfig } = require("../../helper-hardhat-config");
const { getNamedAccounts, deployments, ethers, network } = require("hardhat");
const { assert, expect } = require("chai");
const { experimentalAddHardhatNetworkMessageTraceHook } = require("hardhat/config");

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Erc20", function () {
          let erc20, deployer, marketplace;
          const chainId = network.config.chainId;

          beforeEach(async function () {
              deployer = (await getNamedAccounts()).deployer;
              await deployments.fixture(["all"]);
              erc20 = await ethers.getContract("MyToken", deployer);
              marketplace = await ethers.getContract("MarketPlace", deployer);
          });

          describe("constructor", function () {
              it("Initalizes MINTER_ROLE correctly", async function () {
                  const role = await erc20.MINTER_ROLE();
                  console.log(role.toString());
                  assert.equal(
                      role.toString(),
                      "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6"
                  );
              });
          });
      });
