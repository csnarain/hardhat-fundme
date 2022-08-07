const { ethers, getNamedAccounts, network } = require("hardhat");
const { developmentChains } = require("../../helper-hardhat-config");
const { assert, expect } = require('chai');

if (developmentChains.includes(network.name)) {
    describe.skip;
} else {
    describe('FundMe', function () {
        let fundMe;
        let deployer;
        const sendValue = ethers.utils.parseEther('0.01');
        beforeEach(async function () {
            const { deployer } = await getNamedAccounts();
            console.log('deployer:', await deployer.address);
            fundMe = await ethers.getContract('FundMe', deployer);
        });
        it('should allow people to fund and withdraw', asycnc () => {
            const response = await fundMe.fund({ value: sendValue });
            await response.wait(1);
            await fundMe.cheap_withdraw();
            const endingBalance = await fundMe.provider.getBalance(fundMe.address);
            assert.equal(endingBalance.toString(), '0');
        });
    });
}