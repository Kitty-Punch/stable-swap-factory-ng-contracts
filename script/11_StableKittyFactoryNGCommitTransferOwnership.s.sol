// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {IStableKittyFactoryNG} from "../src/interfaces/IStableKittyFactoryNG.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/10_StableKittyFactoryNGSetFeeReceiver.s.sol:StableKittyFactoryNGSetFeeReceiverScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract StableKittyFactoryNGCommitTransferOwnershipScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        IStableKittyFactoryNG _factory = IStableKittyFactoryNG(address(0x0));
        address _adminFuture = address(0x0);

        console.log("Factory:               ", address(_factory));
        console.log("Current admin:         ", _factory.admin());
        console.log("Future admin:          ", _adminFuture);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        _factory.commit_transfer_ownership(_adminFuture);

        vm.stopBroadcast();
        console.log("StableKittyFactoryNG future admin:", _factory.future_admin());
    }
}
