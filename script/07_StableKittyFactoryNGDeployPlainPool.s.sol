// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {IStableKittyFactoryNG} from "../src/interfaces/IStableKittyFactoryNG.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/07_StableKittyFactoryNGDeployPlainPool.s.sol:StableKittyFactoryNGDeployPlainPoolScript --rpc-url <your-rpc-url> -vvv --broadcast

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
contract StableKittyFactoryNGDeployPlainPoolScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        IStableKittyFactoryNG _factory = IStableKittyFactoryNG(
            address(0x0)
        );
        // uint256 _poolImplId = 0;
        // address _poolImpl = address(0x0);
        // uint256 _metaPoolImplId = 0;
        // address _metaPoolImpl = address(0x0);
        // address _mathImpl = address(0x0);
        // address _viewImpl = address(0x0);

        address uptober = address(0xa540b4Ba1bDe8ADC18728ea367e69D7867c69682);
        address moonvember = address(
            0xaB7d17A87442da38D900F7280947Ad68Fe361d66
        );
        // address bullcember = address(0x44008c1c6d68EF882FEB807c08a300831B48d635);

        address _token0Address = uptober;
        address _token1Address = moonvember;
        string memory _name = "skUP/MOON"; // Example: stETH/ETH
        string memory _symbol = "skUPMOON"; // Example: stETHETH
        uint256 _A = 200;
        uint256 _fee = 4000000; // 0.04%
        uint256 _offpeg_fee_multiplier = 20000000000; // 2
        uint256 _ma_exp_time = 866;
        uint256 _implementation_idx = 0;

        console.log("Factory:       ", address(_factory));
        console.log("Fee receiver:  ", _factory.fee_receiver());
        console.log("Pool Impl:     ", _factory.pool_implementations(0));

        // require(_factory.pool_implementations(_poolImplId) == _poolImpl, "Pool implementation not the same");
        // require(_factory.metapool_implementations(_metaPoolImplId) == _metaPoolImpl, "Metapool implementation not the same");
        // require(_factory.math_implementation() == _mathImpl, "Math implementation not the same");
        // require(_factory.views_implementation() == _viewImpl, "Views implementation not the same");
        // require(_factory.fee_receiver() != address(0), "Fee receiver not set");
        // require(_factory.pool_implementations(_poolImplId) != address(0), "Pool implementation not set");
        // require(_factory.metapool_implementations(_metaPoolImplId) != address(0), "Metapool implementation not set");
        // require(_factory.math_implementation() != address(0), "Math implementation not set");
        // require(_factory.views_implementation() != address(0), "Views implementation not set");
        // require(_coins.length == _asset_types.length, "Coins vs asset types length is not valid");
        // require(_coins.length == _method_ids.length, "Coins vs method ids length is not valid");
        // require(_coins.length == _oracles.length, "Coins vs oracles length is not valid");

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        address _newPool = _factory.deploy_plain_pool(
            _name,
            _symbol,
            _getCoinsList(_token0Address, _token1Address),
            _A,
            _fee,
            _offpeg_fee_multiplier,
            _ma_exp_time,
            _implementation_idx,
            _getAssetTypes(),
            _getMethodIds(),
            _getOracles()
        );

        vm.stopBroadcast();
        console.log("New pool:     ", _newPool);
    }

    function _getCoinsList(
        address _token0,
        address _token1
    ) internal pure returns (address[] memory) {
        address[] memory _coins = new address[](2);
        _coins[0] = address(_token0);
        _coins[1] = address(_token1);
        return _coins;
    }

    function _getAssetTypes() internal pure returns (uint8[] memory) {
        return new uint8[](2); // 0, 0 by default -FIAT-
    }

    function _getMethodIds() internal pure returns (bytes4[] memory) {
        return new bytes4[](2); // 0x00000000 by default
    }

    function _getOracles() internal pure returns (address[] memory) {
        return new address[](2); // address(0x0) by default
    }
}
