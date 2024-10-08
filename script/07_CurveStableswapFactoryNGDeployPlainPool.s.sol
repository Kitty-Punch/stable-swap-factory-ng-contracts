// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ICurveStableswapFactoryNG} from "../src/interfaces/ICurveStableswapFactoryNG.sol";

/*
    forge script ./script/07_CurveStableswapFactoryNGDeployPlainPool.s.sol:CurveStableswapFactoryNGDeployPlainPoolScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs

    Example:

    Cast
        cast send <FACTORY_ADDRESS> --private-key <PRIVATE_KEY> --rpc-url https://testnet.evm.nodes.onflow.org  "deploy_plain_pool(string,string,address[],uint256,uint256,uint256,uint256,uint256,uint8[],bytes4[],address[])(address)" TestPool TP "[0xd3bF53DAC106A0290B0483EcBC89d40FcC961f3e,0xe132751AB5A14ac0bD3Cb40571a9248Ee7a2a9EA]" 200 4000000 20000000000 866 0 "[0,0]" "[0x00000000,0x00000000]" "[0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000]"
    
    Curve UI:
        {
            "func": "deploy_plain_pool",
            "params": [
                "stableCoinApe",
                "stableCoin",
                [
                    "0xdAC17F958D2ee523a2206206994597C13D831ec7",
                    "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
                ],
                200,
                4000000,
                20000000000,
                866,
                0,
                [
                    0,
                    0
                ],
                [
                    "00000000",
                    "00000000"
                ],
                [
                    "0x0000000000000000000000000000000000000000",
                    "0x0000000000000000000000000000000000000000"
                ]
            ]
        }
*/
contract CurveStableswapFactoryNGDeployPlainPoolScript is Script {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        ICurveStableswapFactoryNG _factory = ICurveStableswapFactoryNG(address(0x0));
        uint256 _poolImplId = 0;
        address _poolImpl = address(0x0);
        uint256 _metaPoolImplId = 0;
        address _metaPoolImpl = address(0x0);
        address _mathImpl = address(0x0);
        address _viewImpl = address(0x0);
        address _token0 = address(0x0);
        address _token1 = address(0x0);

        address _token0Address = _token0;
        address _token1Address = _token1;
        string memory _name = "TestPool"; // Example: stETH/ETH
        string memory _symbol = "TP"; // Example: stETHETH
        address[] memory _coins = new address[](2);
        _coins[0] = address(_token0Address);
        _coins[1] = address(_token1Address);
        uint256 _A = 200;
        uint256 _fee = 4000000; // 0.04%
        uint256 _offpeg_fee_multiplier = 20000000000; // 2
        uint256 _ma_exp_time = 866;
        uint256 _implementation_idx = 0;
        uint8[] memory _asset_types = new uint8[](2); // 0, 0 by default -FIAT-
        bytes4[] memory _method_ids = new bytes4[](2); // 0x00000000 by default
        address[] memory _oracles = new address[](2); // address(0x0) by default

        console.log("Factory:       ", address(_factory));
        console.log("Fee receiver:  ", _factory.fee_receiver());

        require(_factory.pool_implementations(_poolImplId) == _poolImpl, "Pool implementation not the same");
        require(_factory.metapool_implementations(_metaPoolImplId) == _metaPoolImpl, "Metapool implementation not the same");
        require(_factory.math_implementation() == _mathImpl, "Math implementation not the same");
        require(_factory.views_implementation() == _viewImpl, "Views implementation not the same");
        require(_factory.fee_receiver() != address(0), "Fee receiver not set");
        require(_factory.pool_implementations(_poolImplId) != address(0), "Pool implementation not set");
        require(_factory.metapool_implementations(_metaPoolImplId) != address(0), "Metapool implementation not set");
        require(_factory.math_implementation() != address(0), "Math implementation not set");
        require(_factory.views_implementation() != address(0), "Views implementation not set");
        require(_coins.length == _asset_types.length, "Coins vs asset types length is not valid");
        require(_coins.length == _method_ids.length, "Coins vs method ids length is not valid");
        require(_coins.length == _oracles.length, "Coins vs oracles length is not valid");

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        address _newPool = _factory.deploy_plain_pool(
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

        vm.stopBroadcast();
        console.log("New pool:     ", _newPool);
    }
}
