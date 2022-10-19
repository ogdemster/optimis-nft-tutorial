const { eth } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  //getContractFactory ile contractımızı değişkene atıyoruz.
  const creatorhomeNFT = await ethers.getContractFactory("CreatorhomeNFT");

  // deploy the myNftContract dont forget to add your Pinata.Cloud Metadata CID
  const creatorhomeNFTontract = await creatorhomeNFT.deploy(
    "ipfs://QmaCGMggGzByfpuGoyRGsfqLLWQMhEi8WofakuMJtKsFtu/"
  );

  //wait for dmyNftContract deployed
  await creatorhomeNFTontract.deployed();

  // show contract address
  console.log("Contract address is:", creatorhomeNFTontract.address);

  console.log("Wait for verify");
  await waitForVerify(100000);

  //dont forget to add your Pinata.Cloud Metadata CID
  await hre.run("verify:verify", {
    address: creatorhomeNFTontract.address,
    constructorArguments: [
      "ipfs://QmaCGMggGzByfpuGoyRGsfqLLWQMhEi8WofakuMJtKsFtu/",
    ],
  });
}

function waitForVerify(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
