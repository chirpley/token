/*
Test file for the Chirpley Token contract.

*/

const { expect } = require("chai");
const { SigningKey } = require("ethers/lib/utils");
const { ethers } = require("hardhat");
const assert = require("truffle-assertions");

describe("Token contract", function () {

  let Token;
  let hardhatToken;
  let owner;
  let addr1;
  let addr2;



  beforeEach(async function () {

    Token = await ethers.getContractFactory("ChirpleyToken");
    [owner, addr1, addr2] = await ethers.getSigners();

    hardhatToken = await Token.deploy();
  });

  describe("Deployment", function () {

    it("Should set the right owner", async function () {

      expect(await hardhatToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {

      await hardhatToken.transfer(addr1.address, 50);
      const addr1Balance = await hardhatToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(50);

      await hardhatToken.connect(addr1).transfer(addr2.address, 50);
      const addr2Balance = await hardhatToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });

    it("Should fail if sender doesn’t have enough tokens", async function () {
      const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

      await expect(
        hardhatToken.connect(addr1).transfer(owner.address, 1)
      ).to.be.revertedWith("ERC20: transfer amount exceeds balance");

      expect(await hardhatToken.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });

    it("Should update balances after transfers", async function () {
      const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

      await hardhatToken.transfer(addr1.address, 100);

      await hardhatToken.transfer(addr2.address, 50);

      // Check balances.
      const finalOwnerBalance = await hardhatToken.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(initialOwnerBalance.sub(150));

      const addr1Balance = await hardhatToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(100);

      const addr2Balance = await hardhatToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });
  });

    
    

  describe("receive", function () { 
    it("Should send ether to the contract and update the account balances mapping", async function () {
      const provider = waffle.provider;
      expect( await provider.getBalance(hardhatToken.address)).to.equal(0);
      console.log(await provider.getBalance(addr1.address));
      const receiveResult = await addr1.sendTransaction({to: hardhatToken.address,value: 100, }); 
      expect( await provider.getBalance(hardhatToken.address)).to.equal(100);
    })
  })
});