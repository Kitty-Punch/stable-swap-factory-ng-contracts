// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";

/*
    forge script ./script/05_CurveStableswapFactoryNGDeploy.s.sol:CurveStableswapFactoryNGDeployScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableswapFactoryNGDeployScript is Script {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";
    string public constant PARAM_OWNER = "OWNER";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        address _owner = vm.envAddress(PARAM_OWNER);
        address _feeReceiver = _owner;

        console.log("Fee receiver:  ", _feeReceiver);
        console.log("Owner:         ", _owner);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        address instance = deployCode(
            "CurveStableswapFactoryNG",
            abi.encode(_feeReceiver, _owner)
        );

        vm.stopBroadcast();
        console.log("CurveStableswapFactoryNG:     ", instance);
    }
}
