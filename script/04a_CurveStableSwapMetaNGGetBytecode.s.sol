// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {VyperDeployer} from "../test/utils/VyperDeployer.sol";

/*
    forge script ./script/04a_CurveStableSwapMetaNGGetBytecode.s.sol:CurveStableSwapMetaNGGetBytecodeScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableSwapMetaNGGetBytecodeScript is Script {

    function run() public {
        console.log("Starting script: broadcasting");

        VyperDeployer deployer = new VyperDeployer();
        console.log("Deployer:       ", address(deployer));
        bytes memory bytecodeBlueprint = deployer.getDeployBytecodeBlueprint("CurveStableSwapMetaNG", "codesize");
        console.log("<<<<<<<<<<<<<<<<<<<<< START CurveStableSwapMetaNG bytecode blueprint >>>>>>>>>>>>>>>>>>>>>");
        console.logBytes(bytecodeBlueprint);
        console.log("<<<<<<<<<<<<<<<<<<<<< END CurveStableSwapMetaNG bytecode blueprint >>>>>>>>>>>>>>>>>>>>>");

        console.log("CurveStableSwapMetaNG bytecode blueprint retrieved...");
    }
}
