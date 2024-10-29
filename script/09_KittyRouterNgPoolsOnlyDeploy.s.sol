// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/09_KittyRouterNgPoolsOnlyDeploy.s.sol:KittyRouterNgPoolsOnlyDeployScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract KittyRouterNgPoolsOnlyDeployScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        address _wflow = address(0x0);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        address instance = deployCode(
            string.concat(KITTY_ROUTER_NG_POOLS_ONLY),
            abi.encode(_wflow)
        );

        vm.stopBroadcast();
        console.log(string.concat(KITTY_ROUTER_NG_POOLS_ONLY, ": "), instance);
    }
}
