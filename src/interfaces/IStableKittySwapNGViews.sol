// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IStableKittySwapNGViews {
    /**
     *
     * @notice Calculate the current input dx given output dy
     * @dev Index values can be found via the `coins` public getter method
     * @param i Index value for the coin to send
     * @param j Index valie of the coin to recieve
     * @param dy Amount of `j` being received after exchange
     * @return Amount of `i` predicted
     */
    function get_dx(
        int128 i,
        int128 j,
        uint256 dy,
        address pool
    ) external view returns (uint256);

    /**
     * @notice Calculate the current output dy given input dx
     * @dev Index values can be found via the `coins` public getter method
     * @param i Index value for the coin to send
     * @param j Index valie of the coin to recieve
     * @param dx Amount of `i` being exchanged
     * @return Amount of `j` predicted
     */
    function get_dy(
        int128 i,
        int128 j,
        uint256 dx,
        address pool
    ) external view returns (uint256);

    function get_dx_underlying(
        int128 i,
        int128 j,
        uint256 dy,
        address pool
    ) external view returns (uint256);

    /**
     * @notice Calculate the current output dy given input dx on underlying
     * @dev Index values can be found via the `coins` public getter method
     * @param i Index value for the coin to send
     * @param j Index valie of the coin to recieve
     * @param dx Amount of `i` being exchanged
     * @return Amount of `j` predicted
     */
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        address pool
    ) external view returns (uint256);

    /**
     * @notice Calculate addition or reduction in token supply from a deposit or withdrawal
     * @dev Only works for StableswapNG pools and not legacy versions
     * @param _amounts Amount of each coin being deposited
     * @param _is_deposit set True for deposits, False for withdrawals
     * @return Expected amount of LP tokens received
     */
    function calc_token_amount(
        uint256[] calldata _amounts,
        bool _is_deposit,
        address pool
    ) external view returns (uint256);

    function calc_withdraw_one_coin(
        uint256 _burn_amount,
        int128 i,
        address pool
    ) external view returns (uint256);

    /**
     * @notice Return the fee for swapping between `i` and `j`
     * @param i Index value for the coin to send
     * @param j Index value of the coin to recieve
     * @return Swap fee expressed as an integer with 1e10 precision
     */
    function dynamic_fee(
        int128 i,
        int128 j,
        address pool
    ) external view returns (uint256);
}
