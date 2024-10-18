// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {VyperDeployer} from "../test/utils/VyperDeployer.sol";

/*
    forge script ./script/03a_CurveStableSwapNGGetBytecode.s.sol:CurveStableSwapNGGetBytecodeScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableSwapNGGetBytecodeScript is Script {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";

    function run() public {
        console.log("Starting script: broadcasting");

        VyperDeployer deployer = new VyperDeployer();
        console.log("Deployer:       ", address(deployer));
        bytes memory bytecodeBlueprint = deployer.getDeployBytecodeBlueprint("CurveStableSwapNG", "codesize");
        console.log("<<<<<<<<<<<<<<<<<<<<< START CurveStableSwapNG bytecode blueprint >>>>>>>>>>>>>>>>>>>>>");
        console.logBytes(bytecodeBlueprint);
        console.log("<<<<<<<<<<<<<<<<<<<<< END CurveStableSwapNG bytecode blueprint >>>>>>>>>>>>>>>>>>>>>");
        
        console.log("CurveStableSwapNG bytecode blueprint retrieved...");
    }
}
