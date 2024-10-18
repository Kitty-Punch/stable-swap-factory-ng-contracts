// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {IStableKittySwapNG} from "../src/interfaces/IStableKittySwapNG.sol";
import {MockToken} from "../test/mocks/MockToken.sol";
import {Consts} from "./Consts.sol";

/*
    forge script ./script/08_StableKittyFactoryNGAddLiquidity.s.sol:StableKittyFactoryNGAddLiquidityScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract StableKittyFactoryNGAddLiquidityScript is Script, Consts {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        address _creator = vm.envAddress(PARAM_OWNER);
        IStableKittySwapNG _pool = IStableKittySwapNG(address(0xd6a5A7BdDBC8973C1fC589720d07f0c171351C67));
        address uptober = address(0xa540b4Ba1bDe8ADC18728ea367e69D7867c69682);
        address moonvember = address(
            0xaB7d17A87442da38D900F7280947Ad68Fe361d66
        );
        address bullcember = address(
            0x44008c1c6d68EF882FEB807c08a300831B48d635
        );

        MockToken _token0 = MockToken(uptober);
        MockToken _token1 = MockToken(moonvember);

        console.log("Starting script: broadcasting");
        vm.startBroadcast(deployerPrivateKey);

        uint256 _token0Amount = 1000e18;
        uint256 _token1Amount = 1000e18;

        _token0.mint(_creator, _token0Amount);
        _token1.mint(_creator, _token1Amount);

        _token0.approve(address(_pool), _token0Amount);
        _token1.approve(address(_pool), _token1Amount);

        uint256[] memory _amounts = new uint256[](2);
        _amounts[0] = _token0Amount;
        _amounts[1] = _token1Amount;

        console.log("Adding liquidity...");
        uint256 _poolShares = _pool.add_liquidity(_amounts, 0);
        console.log("New pool shares:   ", _poolShares);

        console.log("Getting dy...");
        uint256 _dx = 10e18;
        uint256 _dy = _pool.get_dy(0, 1, _dx);
        console.log("Dx:            ", _dx);
        console.log("Dy:            ", _dy);

        console.log("Approving tokens...");
        _token0.mint(_creator, _dx);
        _token0.approve(address(_pool), _dx);
        console.log("Exchanging tokens...");
        uint256 _dySwapped = _pool.exchange(0, 1, _dx, _dy);

        console.log("Dy swapped:    ", _dySwapped);

        console.log("Removing liquidity...");

        uint256 lpToBurn = _poolShares * 10 / 100; // Burn 10% of the pool shares
        console.log("LP to burn: ", lpToBurn);
        uint256[] memory _removeAmounts = new uint256[](2);
        _removeAmounts[0] = (lpToBurn * _token0Amount / _pool.totalSupply()) * 95 / 100;
        _removeAmounts[1] = (lpToBurn * _token1Amount / _pool.totalSupply()) * 95 / 100;
        console.log("Amount Token 0 to remove: ", _removeAmounts[0]);
        console.log("Amount Token 1 to remove: ", _removeAmounts[1]);

        uint256[] memory _poolSharesRemoved = _pool.remove_liquidity(lpToBurn, _removeAmounts);
        console.log("Amount Token 0 Removed: ", _poolSharesRemoved[0]);
        console.log("Amount Token 1 Removed: ", _poolSharesRemoved[1]);

        vm.stopBroadcast();
    }
}
