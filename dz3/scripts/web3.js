const Web3 = require('web3')

var web3 = new Web3(new Web3.providers.HttpProvider("https://goerli.infura.io/v3/ef27e0db5b1e4850b8280c9b64185235"));


const abiOfMyContract = require("../artifacts/contracts/KulakovToken.sol/KulakovToken.json");
const MyContractAddress = "0xeEa84Fa2b2fDe74F520C8C1A281a4e3503130682";

const gettedContact = new web3.eth.Contract(json.abi, MyContractAddress)


gettedContact.methods.createKey().call().then(console.log)
