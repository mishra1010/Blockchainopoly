const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledmultisig = require('./build/AbstractMultiSig.json');

const provider = new HDWalletProvider(
    'gd sweet betray goat brother cupboard parrot quantum nothing curious ridge daer',
    'https://rinkeby.infura.io/VPBDjsyHh1tt57g'
);
const web3 = new Web3(provider);

const deploy = async ()=>{
    const accounts = await web3.eth.getAccounts();
    console.log('attempting to deploy from account', accounts[0]);
 const result =   await new web3.eth.Contract(JSON.parse(compiledmultisig.interface))
        .deploy({ data: compiledmultisig.bytecode })
        .send({ gas:'2000000',from: accounts[0]});

    console.log('deployed address', result.options.address);
};

deploy();