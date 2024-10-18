// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ICurveStableswapFactoryNG} from "../src/interfaces/ICurveStableswapFactoryNG.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/06_CurveStableswapFactoryNGSetImplementations.s.sol:CurveStableswapFactoryNGSetImplementationsScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableswapFactoryNGSetImplementationsScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        ICurveStableswapFactoryNG _factory = ICurveStableswapFactoryNG(address(0xDF16Fa72D525c7ec54E525fFE23617a82FB72D68));
        uint256 _poolImplId = 0;
        address _poolImpl = address(0x07f7767deDa26C3FeB1dCFEFD939cfF920Ac5EcE);
        uint256 _metaPoolImplId = 0;
        address _metaPoolImpl = address(0x9B3B947B93901Ff750327528C3Bd3eCd79CCd503);
        address _mathImpl = address(0xFc4e3d3D57487cab3FB610fB188b6c4514d78008);
        address _viewImpl = address(0xfa7074E024cA8227407cfB07Dd14DF0C3d75b5c6);

        console.log("Factory:       ", address(_factory));
        console.log("Fee receiver:  ", _factory.fee_receiver());

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        _factory.set_pool_implementations(_poolImplId, _poolImpl);
        _factory.set_metapool_implementations(_metaPoolImplId, _metaPoolImpl);
        _factory.set_math_implementation(_mathImpl);
        _factory.set_views_implementation(_viewImpl);
        // DON'T REQUIRE _factory.set_gauge_implementation(address _gauge_implementation);

        require(_factory.pool_implementations(_poolImplId) == _poolImpl, "Pool implementation not set");
        require(_factory.metapool_implementations(_metaPoolImplId) == _metaPoolImpl, "Metapool implementation not set");
        require(_factory.math_implementation() == _mathImpl, "Math implementation not set");
        require(_factory.views_implementation() == _viewImpl, "Views implementation not set");
        require(_factory.fee_receiver() != address(0), "Fee receiver not set");

        vm.stopBroadcast();
        console.log("CurveStableswapFactoryNG instance implementations set properly...");
    }
}
