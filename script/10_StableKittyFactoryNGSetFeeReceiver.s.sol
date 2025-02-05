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
contract StableKittyFactoryNGSetFeeReceiverScript is Script, Consts {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        address _feeReceiver = address(0x0);
        // The pool address is not used in the set_fee_receiver function
        address _pool = address(0x0);
        IStableKittyFactoryNG _factory = IStableKittyFactoryNG(address(0x0));

        console.log("Factory:               ", address(_factory));
        console.log("Current admin:         ", _factory.admin());
        console.log("Current fee receiver:  ", _factory.fee_receiver());
        console.log("New fee receiver:      ", _feeReceiver);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        _factory.set_fee_receiver(_pool, _feeReceiver);

        vm.stopBroadcast();
        console.log("StableKittyFactoryNG fee receiver:", _factory.fee_receiver());
    }
}
