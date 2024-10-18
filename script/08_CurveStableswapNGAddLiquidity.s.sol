// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ICurveStableswapFactoryNG} from "../src/interfaces/ICurveStableswapFactoryNG.sol";
import {ICurveStableSwapNG} from "../src/interfaces/ICurveStableSwapNG.sol";
import {MockToken} from "../test/mocks/MockToken.sol";

/*
    forge script ./script/08_CurveStableswapNGAddLiquidity.s.sol:CurveStableswapNGAddLiquidityScript --rpc-url <your-rpc-url> -vvv --broadcast

    --broadcast to send the tx to the network
    -vvv to see the logs
*/
contract CurveStableswapNGAddLiquidityScript is Script {
    string public constant PARAM_PK_ACCOUNT = "PK_ACCOUNT";
    string public constant PARAM_OWNER = "OWNER";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint(PARAM_PK_ACCOUNT);
        address _creator = vm.envAddress(PARAM_OWNER);
        ICurveStableSwapNG _pool = ICurveStableSwapNG(address(0x0BF8cB3673d72BE42937Fa823813AdEfD01BB58D));
        address uptober = address(0xa540b4Ba1bDe8ADC18728ea367e69D7867c69682);
        address moonvember = address(0xaB7d17A87442da38D900F7280947Ad68Fe361d66);
        address bullcember = address(0x44008c1c6d68EF882FEB807c08a300831B48d635);

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

        uint256 _poolShares = _pool.add_liquidity(_amounts, 0);

        vm.stopBroadcast();
        console.log("Pool shares:   ", _poolShares);

        uint256 _dy = _pool.get_dy(0, 1, 10e18);
        console.log("Dy:            ", _dy);
    }
}
