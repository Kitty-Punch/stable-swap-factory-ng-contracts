// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {console2} from "forge-std/Test.sol";
import {MockToken} from "./mocks/MockToken.sol";
import {IStableKittyFactoryNG} from "../src/interfaces/IStableKittyFactoryNG.sol";
import {StableKittyFactoryNGUtils} from "./StableKittyFactoryNGUtils.sol";
import {IStableKittySwapNG} from "../src/interfaces/IStableKittySwapNG.sol";

contract StableKittyFactoryNGTest is StableKittyFactoryNGUtils {

    address public owner;
    address public feeReceiver;
    uint256 internal forkId;

    IStableKittyFactoryNG public factory;

    function setUp() public override {
        console2.log("Setting up...");
        uint256 forkIdOld = vm.createFork("https://testnet.evm.nodes.onflow.org");
        console2.log("OLD Fork ID: ", forkIdOld);
        forkId = vm.createSelectFork("https://testnet.evm.nodes.onflow.org");
        console2.log("Fork ID: ", forkId);
        assertEq(vm.activeFork(), forkId, "!forkId");
        super.setUp();
        feeReceiver = address(0x88888);
        owner = address(0x99999);

        factory = _deployFactory(feeReceiver, owner);
    }

    function _deployPlainPool(string memory _name, string memory _symbol, address[] memory _coins, uint256 _A) internal returns (IStableKittySwapNG) {
        uint256 _fee = 4000000; // 0.04%
        uint256 _offpeg_fee_multiplier = 20000000000; // 2
        uint256 _ma_exp_time = 866;
        uint256 _implementation_idx = 0;
        uint8[] memory _asset_types = new uint8[](2); // 0, 0 by default -FIAT-
        bytes4[] memory _method_ids = new bytes4[](2); // 0x00000000 by default
        address[] memory _oracles = new address[](2); // address(0x0) by default

        vm.startPrank(owner);
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
        vm.stopPrank();
        return IStableKittySwapNG(_newPool);
    }

    function test_deploy_plain_pool_valid() external {
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

        vm.startPrank(owner);
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
        vm.stopPrank();

        console2.log("New pool:      ", _newPool);
    }

    function test_pool_get_dy_valid(address _creator) external {
        vm.assume(_creator != address(0x0));
        string memory _name = "KP DAI/USDT"; //  stETH/ETH
        string memory _symbol = "kpUSD"; // stETHETH
        MockToken _dai = new MockToken();
        MockToken _usdt = new MockToken();
        address[] memory _coins = new address[](2);
        _coins[0] = address(_dai);
        _coins[1] = address(_usdt);
        uint256 _A = 200;

        IStableKittySwapNG _newPool = _deployPlainPool(_name, _symbol, _coins, _A);

        uint256 _daiAmount = 1000e18;
        uint256 _usdtAmount = 1000e18;

        _dai.mint(_creator, _daiAmount);
        _usdt.mint(_creator, _usdtAmount);

        _dai.approve(address(_newPool), _daiAmount);
        _usdt.approve(address(_newPool), _usdtAmount);

        uint256[] memory _amounts = new uint256[](2);
        _amounts[0] = _daiAmount;
        _amounts[1] = _usdtAmount;

        uint256 _poolShares = _newPool.add_liquidity(_amounts, 0);
        console2.log("Pool shares: ", _poolShares);
        require(_poolShares > 0, "Invalid pool shares");

        uint256 virtualPrice = _newPool.get_virtual_price();
        console2.log("Virtual price: ", virtualPrice);

        uint256 _dy = _newPool.get_dy(0, 1, 10e18);
        console2.log("Amount out: ", _dy);
    }
}
