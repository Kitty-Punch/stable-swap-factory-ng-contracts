// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";
import {Blueprint} from "../src/lib/Blueprint.sol";

/*
    forge script ./script/02_CurveStableSwapNGViewsDeploy.s.sol:CurveStableSwapNGViewsDeployScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableSwapNGViewsDeployScript is Script {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        bytes32 _salt = "";

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        // address instance = deployCode("CurveStableSwapNGViews");
        address instance = _deployCurveStableSwapNGViews(_salt);

        vm.stopBroadcast();
        console.log("CurveStableSwapNGViews:     ", instance);
    }

    function _deployCurveStableSwapNGViews(bytes32 _salt) internal returns (address) {
        bytes memory bytecode = vm.getCode("CurveStableSwapNGViews");
        bytes memory bytecodeBlueprint = Blueprint.blueprintDeployerBytecode(bytecode);
        address instance = Create2.deploy(0, _salt, bytecodeBlueprint);
        return instance;
    }
}
