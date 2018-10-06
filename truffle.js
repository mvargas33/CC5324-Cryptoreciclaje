require('dotenv').config();
const Web3 = require("web3");
const web3 = new Web3();
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');

//var HDWalletProvider = require("truffle-hdwallet-provider");
//var mnemonic = "razor then .......";

var ropstenPrivateKey = new Buffer(process.env["ROPSTEN_PRIVATE_KEY"], "hex")
var ropstenWallet = Wallet.fromPrivateKey(ropstenPrivateKey);
var ropstenProvider = new WalletProvider(ropstenWallet, "https://ropsten.infura.io/");

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  // set the provider you want from Web3.providers
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
     ropsten:  {
    //  provider: function() { 
    //    return new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/b39afa9667b3416783cc68b99e4357d9') 
    //  },
     host: "localhost",
     port:  8545,
     gasPrice: 2900000, 
     network_id: "3",
   },
    rinkeby: {
      provider: rinkebyProvider,
      gas: 4600000,
      gasPrice: web3.toWei("20", "gwei"),
      network_id: "4",
    },
    mainnet: {
    	host: "*",
    	port: 8545,
    	network_id: "1"
    }
  }
};
