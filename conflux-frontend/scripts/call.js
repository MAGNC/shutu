const { Conflux, util } = require('js-conflux-sdk');
//合约持有者地址
const public_address = '0x17b38613e633c2b8fb4686a3a62b9b782ac5e0ca';
// 部署合约地址的地址，与0x17b38613e633c2b8fb4686a3a62b9b782ac5e0ca关联：上面已经进行解释
const contractAddress = '0x846ba74923c670a5aec4e58b7551396b9bed5658';
const PRIVATE_KEY = '0x2772b19636f1d183a9a2a0d27da2a1d0efb97637b425********************';
const compiled = require(`./build/ERC20.json`)
async function main() {
  const cfx = new Conflux({
    url: 'http://main.confluxrpc.org',
  });
  const contract = cfx.Contract({
    address : contractAddress,
    abi: compiled.abi,
  });
  // 查看供应总量
  let result = await contract.totalSupply();
  console.log("Total supply:"  + result.toString());
  const account = cfx.Account(PRIVATE_KEY);
  
  //查看账户余额
  let balance = await contract.balanceOf(public_address);
  console.log("address:"+public_address+" have balance:"+balance.toString());//这是部署合约的账户公开地址
  
  //尝试进行交易
  let allowance_result=await contract.allowance(public_address,'0x1941E3137aDDf02514cBFeC292710463d41e8196');
  console.log("tx:"+allowance_result);
  
  approve_result=await contract.approve(transfer_address,1000);
  console.log("approve result:"+approve_result);
  //尝试进行转账操作
  let transfer_balance=await contract.balanceOf(transfer_address);
  console.log("address:"+transfer_address+" have balance:"+transfer_balance.toString());
  
  await contract.transfer(transfer_address,100).sendTransaction({
	  from: account
  }).confirmed();
  
  let transfer_balance_after=await contract.balanceOf(transfer_address);
  console.log("after transfer address:"+transfer_address+" have balance:"+transfer_balance_after.toString());
  
}
main().catch(e => console.error(e));
