// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";

/*
    forge script ./script/01_CurveStableSwapNGMathDeploy.s.sol:CurveStableSwapNGMathDeployScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableSwapNGMathDeployScript is Script {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        address instance = deployCode("CurveStableSwapNGMath");

        vm.stopBroadcast();
        console.log("CurveStableSwapNGMath:     ", instance);
    }
}
