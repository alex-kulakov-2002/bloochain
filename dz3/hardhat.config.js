/** @type import('hardhat/config').HardhatUserConfig */

require('@nomiclabs/hardhat-ethers')
require('@nomicfoundation/hardhat-chai-matchers')
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.17",
};

const GOERLI_PRIVATE_KEY = "cf26349f5d4a7e32858fcda2cdc97bff180c87a5081ebdaecd4786894f15d29d";
module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/ef27e0db5b1e4850b8280c9b64185235`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }
};
