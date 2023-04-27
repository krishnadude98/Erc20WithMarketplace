const { developmentChains, networkConfig } = require("../../helper-hardhat-config");
const { getNamedAccounts, deployments, ethers, network } = require("hardhat");
const { assert, expect } = require("chai");
const { experimentalAddHardhatNetworkMessageTraceHook } = require("hardhat/config");
const { time, mine } = require("@nomicfoundation/hardhat-network-helpers");

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

describe("Testing Marketplace", function () {
    let erc20, deployer, marketplace;
    const chainId = network.config.chainId;
    let p1, p2, p3, price;

    beforeEach(async function () {
        deployer = (await getNamedAccounts()).deployer;
        await deployments.fixture(["all"]);
        erc20 = await ethers.getContract("MyToken", deployer);
        marketplace = await ethers.getContract("MarketPlace", deployer);
        price = await marketplace.price();
        [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15] =
            await ethers.getSigners();
    });

    it("allows to buy multiple times", async function () {
        await marketplace.connect(p1).buyToken({ value: price });
        await marketplace.connect(p1).buyToken({ value: price });
        let myobj1 = await marketplace.connect(p1).waitinglist(p1.address, 0);
        let myobj2 = await marketplace.connect(p1).waitinglist(p1.address, 1);
        expect(myobj1.timeBuyed < myobj2.timeBuyed);
    });

    it("allows to claim tokens after 1 year", async function () {
        let price2 = Number(price) * 2;
        let price3 = Number(price) * 3;
        await marketplace.connect(p1).buyToken({ value: price });
        await marketplace.connect(p1).buyToken({ value: price2.toString() });
        await marketplace.connect(p1).buyToken({ value: price3.toString() });

        const threesixtyfivedays = 365 * 24 * 60 * 60;
        await network.provider.send("evm_increaseTime", [threesixtyfivedays]);
        await network.provider.send("evm_mine");
        await marketplace.connect(p1).claimToken(2);
        await marketplace.connect(p1).claimToken(1);
        await marketplace.connect(p1).claimToken(0);

        let balance = await erc20.connect(p1).balanceOf(p1.address);
        assert.equal(balance.toString(), "6");
    });
});
