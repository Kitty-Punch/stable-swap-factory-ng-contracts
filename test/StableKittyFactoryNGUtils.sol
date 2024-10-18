// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {MockToken} from "./mocks/MockToken.sol";
import {IStableKittyFactoryNG} from "../src/interfaces/IStableKittyFactoryNG.sol";
import {VyperDeployer} from "./utils/VyperDeployer.sol";
import {Consts} from "../script/Consts.sol";

abstract contract StableKittyFactoryNGUtils is Test, Consts {

    VyperDeployer internal deployer;

    function setUp() public virtual {
        deployer = new VyperDeployer();
    }

    function _deployFactory(
        address _feeReceiver,
        address _owner
    ) internal returns (IStableKittyFactoryNG) {
        address _curveStableSwapNGMath = _deployStableKittyMetaNGMath(_owner);
        address _curveStableSwapNGViews = _deployStableKittySwapNGViews(_owner);
        address _curveStableSwapNG = _deployStableKittySwapNG(_owner);
        address _stableKittySwapMetaNG = _deployStableKittySwapMetaNG(_owner);
        IStableKittyFactoryNG _curveStableSwapFactoryNG = IStableKittyFactoryNG(
                _deployStableKittyFactoryNG(_feeReceiver, _owner)
            );

        vm.startPrank(_owner);
        _curveStableSwapFactoryNG.set_pool_implementations(
            0,
            _curveStableSwapNG
        );
        _curveStableSwapFactoryNG.set_metapool_implementations(
            0,
            _stableKittySwapMetaNG
        );
        _curveStableSwapFactoryNG.set_math_implementation(
            _curveStableSwapNGMath
        );
        _curveStableSwapFactoryNG.set_views_implementation(
            _curveStableSwapNGViews
        );
        vm.stopPrank();
        return _curveStableSwapFactoryNG;
    }

    function _deployStableKittyMetaNGMath(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode(STABLE_KITTY_SWAP_NG_MATH);
        vm.stopPrank();
        return instance;
    }

    function _deployStableKittySwapNGViews(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode(STABLE_KITTY_SWAP_NG_VIEWS);
        vm.stopPrank();
        return instance;
    }

    function _deployStableKittySwapNG(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        bytes memory bytecodeBlueprint = deployer.getDeployBytecodeBlueprint(STABLE_KITTY_SWAP_NG, "codesize");
        address instance = _deployCode(bytecodeBlueprint, "");
        vm.stopPrank();
        return instance;
    }

    function _deployStableKittySwapMetaNG(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        bytes memory bytecodeBlueprint = deployer.getDeployBytecodeBlueprint(STABLE_KITTY_SWAP_META_NG, "codesize");
        address instance = _deployCode(bytecodeBlueprint, "");
        vm.stopPrank();
        return instance;
    }

    function _deployCode(bytes memory bytecode, bytes memory args) internal virtual returns (address addr) {
        uint256 val = 0;
        bytes memory bytecodeWithArgs;
        if (args.length == 0) {
            bytecodeWithArgs = bytecode;
        } else {
            bytecodeWithArgs = abi.encodePacked(bytecode, args);
        }
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecodeWithArgs, 0x20), mload(bytecodeWithArgs))
        }

        require(addr != address(0), "CustomUtils deployCode(bytes,bytes): Deployment failed.");
    }

    function _deployStableKittyFactoryNG(
        address _feeReceiver,
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode(
            STABLE_KITTY_FACTORY_NG,
            abi.encode(_feeReceiver, _owner)
        );
        vm.stopPrank();
        return instance;
    }
}
