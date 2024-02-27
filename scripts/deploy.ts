import { ethers } from "hardhat";

async function main() {

  const SocialMedia = await ethers.deployContract("SocialMedia");

  await SocialMedia.waitForDeployment();

  console.log("SocialMedia deployed to:", SocialMedia.target);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
