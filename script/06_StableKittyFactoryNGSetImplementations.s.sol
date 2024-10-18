// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {IStableKittyFactoryNG} from "../src/interfaces/IStableKittyFactoryNG.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/06_StableKittyFactoryNGSetImplementations.s.sol:StableKittyFactoryNGSetImplementationsScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract StableKittyFactoryNGSetImplementationsScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        IStableKittyFactoryNG _factory = IStableKittyFactoryNG(address(0xf4849506e929f9041dEec3D8C7d7d47230920e54));
        uint256 _poolImplId = 0;
        address _poolImpl = address(0xaA01f74e2310f6C1A105EbC39f6f143a28c05655);
        uint256 _metaPoolImplId = 0;
        address _metaPoolImpl = address(0x2F8Bc9115FF151150D48aa9eBC9fad2555E04f5f);
        address _mathImpl = address(0xd8e4f6DEb6d4eDF7665fAc0fD234da339f106Aea);
        address _viewImpl = address(0x6eA2D53D70b323Bc24F8dD168cb9e28Cc70EBfd2);

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
        console.log("StableKittyFactoryNG instance implementations set properly...");
    }
}
