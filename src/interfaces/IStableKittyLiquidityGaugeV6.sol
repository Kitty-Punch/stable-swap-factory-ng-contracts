// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IStableKittyLiquidityGaugeV6 is IERC20 {
    // State Changing Functions
    function deposit(uint256 _value, address _addr, bool _claim_rewards) external;
    function deposit(uint256 _value, address _addr) external;
    function deposit(uint256 _value) external;
    function withdraw(uint256 _value, bool _claim_rewards) external;
    function withdraw(uint256 _value) external;
    function claim_rewards(address _addr, address _receiver) external;
    function claim_rewards(address _addr) external;
    function claim_rewards() external;
    function set_rewards_receiver(address _receiver) external;

    // View Functions
    function claimed_reward(address _addr, address _token) external view returns (uint256);
    function claimable_reward(address _user, address _reward_token) external view returns (uint256);
    function claimable_tokens(address addr) external returns (uint256);

    function version() external view returns (string memory);
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function lp_token() external view returns (address);
    function is_killed() external view returns (bool);
    function reward_count() external view returns (uint256);
    function reward_data(address)
        external
        view
        returns (
            address token,
            address distributor,
            uint256 period_finish,
            uint256 rate,
            uint256 last_update,
            uint256 integral
        );
    function rewards_receiver(address) external view returns (address);

    function period() external view returns (int128);
    function reward_tokens(uint256) external view returns (address);
}
