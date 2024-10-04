// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20PresetFixedSupply} from "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract MockToken is ERC20PresetFixedSupply {
    constructor()
        ERC20PresetFixedSupply(
            "MockToken",
            "MT",
            900000000 * 10 ** 18,
            msg.sender
        )
    {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
