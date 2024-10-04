// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {console2} from "forge-std/Test.sol";
import {MockToken} from "./mocks/MockToken.sol";
import {ICurveStableswapFactoryNG} from "../src/interfaces/ICurveStableswapFactoryNG.sol";
import {CurveStableswapNGUtils} from "./CurveStableswapNGUtils.sol";

contract CurveStableswapFactoryNGTest is CurveStableswapNGUtils {

    address public owner;
    address public feeReceiver;

    ICurveStableswapFactoryNG public factory;

    function setUp() public {
        feeReceiver = address(0x88888);
        owner = address(0x99999);

        vm.startPrank(owner);
        factory = _deployFactory(feeReceiver, owner);
        vm.stopPrank();
    }

    function test_deploy_plain_pool_valid(address ownerAddress) external {
        assertTrue(factory.math_implementation() != address(0x0), "math_implementation should not be 0x0");
        assertTrue(factory.views_implementation() != address(0x0), "views_implementation should not be 0x0");
        assertTrue(factory.pool_implementations(0) != address(0x0), "pool_implementations should not be 0x0");
        assertTrue(factory.metapool_implementations(0) != address(0x0), "metapool_implementations should not be 0x0");

        MockToken _dai = new MockToken();
        MockToken _usdt = new MockToken();

        console2.log("DAI:           ", address(_dai));
        console2.log("USDT:          ", address(_usdt));

        string memory _name = "KP DAI/USDT"; //  stETH/ETH
        string memory _symbol = "kpUSD"; // stETHETH
        address[] memory _coins = new address[](2);
        _coins[0] = address(_dai);
        _coins[1] = address(_usdt);
        uint256 _A = 200;
        uint256 _fee = 4000000; // 0.04%
        uint256 _offpeg_fee_multiplier = 20000000000; // 2
        uint256 _ma_exp_time = 866;
        uint256 _implementation_idx = 0;
        uint8[] memory _asset_types = new uint8[](2); // 0, 0 by default -FIAT-
        bytes4[] memory _method_ids = new bytes4[](2); // 0x00000000 by default
        address[] memory _oracles = new address[](2); // address(0x0) by default

        address _newPool = factory.deploy_plain_pool(
            _name,
            _symbol,
            _coins,
            _A,
            _fee,
            _offpeg_fee_multiplier,
            _ma_exp_time,
            _implementation_idx,
            _asset_types,
            _method_ids,
            _oracles
        );

        console2.log("New pool:      ", _newPool);
    }
}
