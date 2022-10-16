async function main() {
    const [deployer] = await ethers.getSigners();


    console.log("Account", deployer.address);


    console.log("Balance:", (await deployer.getBalance()).toString());
    const Token = await ethers.getContractFactory("DZ2");
    const token = await Token.deploy();

    console.log("Address:", token.address);
  }

  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });