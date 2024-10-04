// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {MockToken} from "./mocks/MockToken.sol";
import {ICurveStableswapFactoryNG} from "../src/interfaces/ICurveStableswapFactoryNG.sol";

abstract contract CurveStableswapNGUtils is Test {
    function _deployFactory(
        address _feeReceiver,
        address _owner
    ) internal returns (ICurveStableswapFactoryNG) {
        address _curveStableSwapNGMath = _deployCurveStableSwapNGMath(_owner);
        address _curveStableSwapNGViews = _deployCurveStableSwapNGViews(_owner);
        address _curveStableSwapNG = _deployCurveStableSwapNG(_owner);
        address _curveStableSwapMetaNG = _deployCurveStableSwapMetaNG(_owner);
        ICurveStableswapFactoryNG _curveStableSwapFactoryNG = ICurveStableswapFactoryNG(
                _deployCurveStableSwapFactoryNG(_feeReceiver, _owner)
            );

        _curveStableSwapFactoryNG.set_pool_implementations(
            0,
            _curveStableSwapNG
        );
        _curveStableSwapFactoryNG.set_metapool_implementations(
            0,
            _curveStableSwapMetaNG
        );
        _curveStableSwapFactoryNG.set_math_implementation(
            _curveStableSwapNGMath
        );
        _curveStableSwapFactoryNG.set_views_implementation(
            _curveStableSwapNGViews
        );
        return _curveStableSwapFactoryNG;
    }

    function _deployCurveStableSwapNGMath(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode("CurveStableSwapNGMath");
        vm.stopPrank();
        return instance;
    }

    function _deployCurveStableSwapNGViews(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode("CurveStableSwapNGViews");
        vm.stopPrank();
        return instance;
    }

    function _deployCurveStableSwapNG(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode(
            "CurveStableSwapNG",
            abi.encode(
                "", // _name: String[32],
                "", // _symbol: String[10],
                0, // _A: uint256,
                0, // _fee: uint256,
                0, // _offpeg_fee_multiplier: uint256,
                1, // _ma_exp_time: uint256,
                new address[](0), // _coins: DynArray[address, MAX_COINS],
                new uint256[](0), // _rate_multipliers: DynArray[uint256, MAX_COINS],
                new uint8[](0), // _asset_types: DynArray[uint8, MAX_COINS],
                new bytes4[](0), // _method_ids: DynArray[bytes4, MAX_COINS],
                new address[](0) // _oracles: DynArray[address, MAX_COINS],
            )
        );
        vm.stopPrank();
        return instance;
    }

    function _deployCurveStableSwapMetaNG(
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode(
            "CurveStableSwapMetaNG",
            abi.encode(
                "", // _name: String[32]
                "", // _symbol: String[10]
                0, // _A: uint256
                0, // _fee: uint256
                0, // _offpeg_fee_multiplier: uint256,
                1, // _ma_exp_time: uint256,
                address(0x0), // _math_implementation: address,
                address(0x0), // _base_pool: address,
                new address[](0), // _coins: DynArray[address, MAX_COINS],
                new address[](0), // _base_coins: DynArray[address, MAX_COINS],
                new uint256[](1), // _rate_multipliers: DynArray[uint256, MAX_COINS],
                new uint8[](1), // _asset_types: DynArray[uint8, MAX_COINS],
                new bytes4[](1), // _method_ids: DynArray[bytes4, MAX_COINS],
                new address[](1) // _oracles: DynArray[address, MAX_COINS],
            )
        );
        vm.stopPrank();
        return instance;
    }

    function _deployCurveStableSwapFactoryNG(
        address _feeReceiver,
        address _owner
    ) internal returns (address) {
        vm.startPrank(_owner);
        address instance = deployCode(
            "CurveStableswapFactoryNG",
            abi.encode(_feeReceiver, _owner)
        );
        vm.stopPrank();
        return instance;
    }
}
