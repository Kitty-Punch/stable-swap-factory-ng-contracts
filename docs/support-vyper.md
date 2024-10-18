# Deploy Vyper contracts

In order to deploy a smart contract in Vyper, use this function as example in your test file:

```solidity
function _deployContract(string memory path, string memory fileName, address _deployer, address param1) internal returns (address) {
    VyperDeployer vyperDeployer = new VyperDeployer();
    
    vm.startPrank(_deployer);
    address contract = vyperDeployer.deployContract(path, fileName, abi.encode(param1));
    vm.stopPrank();
    return contract;
}

```
