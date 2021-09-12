// 私钥，
const PRIVATE_KEY = '';
// 合约地址
const CONTRACT = '';
const { Conflux } = require('js-conflux-sdk');
const compiled = require(`./build/${process.argv[2]}.json`);
const config = require('./config.json');

async function main() {
  const cfx = new Conflux({
    url: 'http://main.confluxrpc.org',
  });
  const account = cfx.Account(PRIVATE_KEY); // create account instance
  console.log(account.address); 

  // create contract instance
  const contract = cfx.Contract({
	  
    abi: compiled.abi,
    bytecode: compiled.bytecode,
  });
  //console.log(contract.address)
  const receipt = await contract.constructor(config["decimals"], config["symbol"], config["name"], config["total_supply"])
    .sendTransaction({ from: account })
    .confirmed();
  console.log("recv:"+receipt.contractCreated); 
}
main().catch(e => console.error(e));
