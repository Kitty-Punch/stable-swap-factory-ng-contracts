// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/03_CurveStableSwapNGDeploy.s.sol:CurveStableSwapNGDeployScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableSwapNGDeployScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        string memory contractName = CURVE_STABLE_SWAP_NG;

        bytes memory deployBytecode = _getBytecodeBlueprint(
            contractName,
            false
        );
        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        ///@notice check that the deployment was successful
        address instance;
        assembly {
            instance := create(
                0,
                add(deployBytecode, 0x20),
                mload(deployBytecode)
            )
        }

        require(instance != address(0), "Could not deploy contract");

        vm.stopBroadcast();
        console.log(string.concat(contractName, ":  "), instance);
    }
}
