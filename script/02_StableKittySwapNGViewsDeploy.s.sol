// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/02_StableKittySwapNGViewsDeploy.s.sol:StableKittySwapNGViewsDeployScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract StableKittySwapNGViewsDeployScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        address instance = deployCode(STABLE_KITTY_SWAP_NG_VIEWS);

        vm.stopBroadcast();
        console.log(
            string.concat(STABLE_KITTY_SWAP_NG_VIEWS, ":    "),
            instance
        );
    }
}
