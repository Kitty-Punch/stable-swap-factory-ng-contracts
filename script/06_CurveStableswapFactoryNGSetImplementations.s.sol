// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ICurveStableswapFactoryNG} from "../src/interfaces/ICurveStableswapFactoryNG.sol";

/*
    forge script ./script/06_CurveStableswapFactoryNGSetImplementations.s.sol:CurveStableswapFactoryNGSetImplementationsScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableswapFactoryNGSetImplementationsScript is Script {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        ICurveStableswapFactoryNG _factory = ICurveStableswapFactoryNG(address(0x0699C35C0104e478f510531F5Dfc3F9313ae49D1));
        uint256 _poolImplId = 0;
        address _poolImpl = address(0x3f2EfC4f851759C6B677b53C7520CDEcD749c94a);
        uint256 _metaPoolImplId = 0;
        address _metaPoolImpl = address(0x9fcF233e3CD6256CCAD53ce355e93ce318d613a1);
        address _mathImpl = address(0x73B810FeEb9e328f2b9a0440BAa3d154F80a7FFe);
        address _viewImpl = address(0xa9D53F87C2629FC4C723BC93Cd29Aa1F002b1B3A); 

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
