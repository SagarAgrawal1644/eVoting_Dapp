// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const votingContract = await hre.ethers.getContractFactory("Voting");
  const deployedVotingContract = await votingContract.deploy();

  console.log(`Contract Address deployed: ${deployedVotingContract.target}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// contract address deployed : 0x23a1612f8Cc310bbdF073C10bCFf16e6Ee69b7A2
// https://mumbai.polygonscan.com/address/0x23a1612f8Cc310bbdF073C10bCFf16e6Ee69b7A2#code