// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {console2 as console} from "forge-std/console2.sol";
import {VyperDeployer} from "../test/utils/VyperDeployer.sol";

abstract contract Consts {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";
    string public constant PARAM_OWNER = "OWNER";
    string constant CURVE_STABLE_SWAP_FACTORY_NG = "CurveStableswapFactoryNG";
    string constant CURVE_STABLE_SWAP_META_NG = "CurveStableSwapMetaNG";
    string constant CURVE_STABLE_SWAP_NG = "CurveStableSwapNG";
    string constant CURVE_STABLE_SWAP_NG_MATH = "CurveStableSwapNGMath";
    string constant CURVE_STABLE_SWAP_NG_VIEWS = "CurveStableSwapNGViews";

    function _getBytecodeBlueprint(
        string memory _contractName,
        bool _printBytecode
    ) internal returns (bytes memory) {
        VyperDeployer deployer = new VyperDeployer();
        console.log("Getting bytecode blueprint for: ", _contractName);
        bytes memory bytecodeBlueprint = deployer.getDeployBytecodeBlueprint(
            _contractName,
            "codesize"
        );
        if (_printBytecode) {
            console.log(
                "<<<<<<<<<<<<<<<<<<<<< START bytecode blueprint >>>>>>>>>>>>>>>>>>>>>"
            );
            console.logBytes(bytecodeBlueprint);
            console.log(
                "<<<<<<<<<<<<<<<<<<<<< END bytecode blueprint >>>>>>>>>>>>>>>>>>>>>"
            );
        }
        console.log("Contract codesize: ", bytecodeBlueprint.length);
        return bytecodeBlueprint;
    }
}
