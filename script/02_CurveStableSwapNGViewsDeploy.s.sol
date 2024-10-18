// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/02_CurveStableSwapNGViewsDeploy.s.sol:CurveStableSwapNGViewsDeployScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableSwapNGViewsDeployScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        address instance = deployCode(CURVE_STABLE_SWAP_NG_VIEWS);

        vm.stopBroadcast();
        console.log(
            string.concat(CURVE_STABLE_SWAP_NG_VIEWS, ":    "),
            instance
        );
    }
}
