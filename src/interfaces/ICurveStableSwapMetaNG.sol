// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * 
 * @title CurveStableSwapMetaNG
 * @author Curve.Fi
 * @notice Stableswap Metapool implementation for 2 coins. Supports pegged assets.
 * @dev Metapools are pools where the coin on index 1 is a liquidity pool token
     of another pool. This exposes methods such as exchange_underlying, which
     exchanges token 0 <> token b1, b2, .. bn, where b is base pool and bn is the
     nth coin index of the base pool.
     CAUTION: Does not work if base pool is an NG pool. Use a different metapool
              implementation index in the factory.
     Asset Types:
        0. Standard ERC20 token with no additional features.
                          Note: Users are advised to do careful due-diligence on
                                ERC20 tokens that they interact with, as this
                                contract cannot differentiate between harmless and
                                malicious ERC20 tokens.
        1. Oracle - token with rate oracle (e.g. wstETH)
                    Note: Oracles may be controlled externally by an EOA. Users
                          are advised to proceed with caution.
        2. Rebasing - token with rebase (e.g. stETH).
                      Note: Users and Integrators are advised to understand how
                            the AMM contract works with rebasing balances.
        3. ERC4626 - token with convertToAssets method (e.g. sDAI).
                     Note: Some ERC4626 implementations may be susceptible to
                           Donation/Inflation attacks. Users are advised to
                           proceed with caution.
        NOTE: Pool Cannot support tokens with multiple asset types: e.g. ERC4626
              with fees are not supported.
     Supports:
        1. ERC20 support for return True/revert, return True/False, return None
        2. ERC20 tokens can have arbitrary decimals (<=18).
        3. ERC20 tokens that rebase (either positive or fee on transfer)
        4. ERC20 tokens that have a rate oracle (e.g. wstETH, cbETH, sDAI, etc.)
           Note: Oracle precision _must_ be 10**18.
        5. ERC4626 tokens with arbitrary precision (<=18) of Vault token and underlying
           asset.
     Additional features include:
        1. Adds oracles based on AMM State Price (and _not_ last traded price).
           State prices are calculated _after_ liquidity operations, using bonding
           curve math.
        2. Adds an exponential moving average oracle for D.
        3. `exchange_received`: swaps that expect an ERC20 transfer to have occurred
           prior to executing the swap.
           Note: a. If pool contains rebasing tokens and one of the `asset_types` is 2 (Rebasing)
                    then calling `exchange_received` will REVERT.
                 b. If pool contains rebasing token and `asset_types` does not contain 2 (Rebasing)
                    then this is an incorrect implementation and rebases can be
                    stolen.
        4. Adds `get_dx`, `get_dx_underlying`: Similar to `get_dy` which returns an expected output
           of coin[j] for given `dx` amount of coin[i], `get_dx` returns expected
           input of coin[i] for an output amount of coin[j].
        5. Fees are dynamic: AMM will charge a higher fee if pool depegs. This can cause very
                             slight discrepancies between calculated fees and realised fees.
 */
interface ICurveStableSwapMetaNG is IERC20 {
    function MAX_COINS() external view returns (uint256);

    function MAX_COINS_128() external view returns (uint128);

    function MAX_METAPOOL_COIN_INDEX() external view returns (int128);

    function asset_types(uint8 _asset) external view returns (string memory);

    function pool_list(uint256 _index) external view returns (address);

    function N_COINS() external view returns (uint256);

    function N_COINS_128() external view returns (uint128);

    function PRECISION() external view returns (uint256);

    function BASE_POOL() external view returns (address);

    function BASE_POOL_IS_NG() external view returns (bool);

    function BASE_N_COINS() external view returns (uint256);

    function BASE_COINS(uint256 _index) external view returns (address);

    function math() external view returns (address);

    function factory() external view returns (address);

    function coins(address _index) external view returns (uint256);

    function asset_type(uint256 _index) external view returns (uint8);

    function pool_contains_rebasing_tokens() external view returns (bool);

    function stored_balances(uint256 _index) external view returns (uint256);

    function FEE_DENOMINATOR() external view returns (uint256);

    function fee() external view returns (uint256);

    function offpeg_fee_multiplier() external view returns (uint256);

    function admin_fee() external view returns (uint256);

    function MAX_FEE() external view returns (uint256);

    function A_PRECISION() external view returns (uint256);

    function MAX_A() external view returns (uint256);

    function MAX_A_CHANGE() external view returns (uint256);

    function initial_A() external view returns (uint256);

    function future_A() external view returns (uint256);

    function initial_A_time() external view returns (uint256);

    function future_A_time() external view returns (uint256);

    function MIN_RAMP_TIME() external view returns (uint256);

    function admin_balances(uint256 _index) external view returns (uint256);

    function rate_multiplier() external view returns (uint256);

    function rate_oracle() external view returns (uint256);

    // For ERC4626 tokens
    function call_amount() external view returns (uint256);

    // For ERC4626 tokens
    function scale_factor() external view returns (uint256);

    // packing: last_price, ma_price
    function last_prices_packed() external view returns (uint256);

    // packing: last_D, ma_D
    function last_D_packed() external view returns (uint256);

    function ma_exp_time() external view returns (uint256);

    function D_ma_time() external view returns (uint256);

    // packing: ma_last_time_p, ma_last_time_D
    function ma_last_time() external view returns (uint256);

    // shift(2**32 - 1, 224) = (2**32 - 1) * 256**28
    function ORACLE_BIT_MASK() external view returns (uint256);

    function version() external view returns (string memory);

    function total_supply() external view returns (uint256);

    function nonces(address _index) external view returns (uint256);

    // keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
    function ERC1271_MAGIC_VAL() external view returns (bytes32);

    // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
    function EIP712_TYPEHASH() external view returns (bytes32);

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
    function EIP2612_TYPEHASH() external view returns (bytes32);

    function VERSION_HASH() external view returns (bytes32);

    function NAME_HASH() external view returns (bytes32);

    function CACHED_CHAIN_ID() external view returns (uint256);

    function salt() external view returns (bytes32);

    function CACHED_DOMAIN_SEPARATOR() external view returns (bytes32);

    function exchange(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy,
        address _receiver
    ) external returns (uint256);

    function exchange(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy
    ) external returns (uint256);

    function exchange_received(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy,
        address _receiver
    ) external returns (uint256);

    function exchange_received(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy
    ) external returns (uint256);

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy,
        address _receiver
    ) external returns (uint256);

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy
    ) external returns (uint256);

    function add_liquidity(
        uint256[] calldata _amounts,
        uint256 _min_mint_amount,
        address _receiver
    ) external returns (uint256);

    function add_liquidity(
        uint256[] calldata _amounts,
        uint256 _min_mint_amount
    ) external returns (uint256);

    function remove_liquidity_one_coin(
        uint256 _burn_amount,
        int128 i,
        uint256 _min_received,
        address _receiver
    ) external returns (uint256);

    function remove_liquidity_one_coin(
        uint256 _burn_amount,
        int128 i,
        uint256 _min_received
    ) external returns (uint256);

    function remove_liquidity_imbalance(
        uint256[] calldata _amounts,
        uint256 _max_burn_amount,
        address _receiver
    ) external returns (uint256);

    function remove_liquidity_imbalance(
        uint256[] calldata _amounts,
        uint256 _max_burn_amount
    ) external returns (uint256);

    function remove_liquidity(
        uint256 _burn_amount,
        uint256[] calldata _min_amounts,
        address _receiver,
        bool _claim_admin_fees
    ) external returns (uint256[] memory);

    function remove_liquidity(
        uint256 _burn_amount,
        uint256[] calldata _min_amounts,
        address _receiver
    ) external returns (uint256[] memory);

    function remove_liquidity(
        uint256 _burn_amount,
        uint256[] calldata _min_amounts
    ) external returns (uint256[] memory);

    function withdraw_admin_fees() external;

    function last_price(uint256 i) external view returns (uint256);

    function ema_price(uint256 i) external view returns (uint256);

    /**
     *
     * @notice Returns the AMM State price of token
     * @dev if i = 0, it will return the state price of coin[1].
     * @param i index of state price (0 for coin[1], 1 for coin[2], ...)
     * @return uint256 The state price quoted by the AMM for coin[i+1]
     */
    function get_p(uint256 i) external view returns (uint256);

    function price_oracle(uint256 i) external view returns (uint256);

    function D_oracle() external view returns (uint256);

    function permit(
        address _owner,
        address _spender,
        uint256 _value,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /**
     * @notice Calculate the current input dx given output dy
     * @dev Index values can be found via the `coins` public getter method
     * @param i Index value for the coin to send
     * @param j Index value of the coin to receive
     * @param dy Amount of `j` being received after exchange
     * @return Amount of `i` predicted
     */
    function get_dx(
        int128 i,
        int128 j,
        uint256 dy
    ) external view returns (uint256);

    /**
     * @notice Calculate the current input dx given output dy
     * @dev Swap involves base pool tokens (either i or j should be 0);
     *      If not, this method reverts.
     * @param i Index value for the coin to send
     * @param j Index value of the coin to receive
     * @param dy Amount of `j` being received after exchange
     * @return Amount of `i` predicted
     */
    function get_dx_underlying(
        int128 i,
        int128 j,
        uint256 dy
    ) external view returns (uint256);

    /**
     * @dev Swap involves base pool tokens (either i or j should be 0);
     *      If not, this method reverts.
     * @param i Index value for the coin to send
     * @param j Index value of the coin to receive
     * @param dx Amount of `i` being exchanged
     * @return Amount of `j` predicted
     */
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256);

    /**
     * @notice Calculate the amount received when withdrawing a single coin
     * @param _burn_amount Amount of LP tokens to burn in the withdrawal
     * @param i Index value of the coin to withdraw
     * @return Amount of coin received
     */
    function calc_withdraw_one_coin(
        uint256 _burn_amount,
        int128 i
    ) external view returns (uint256);

    /**
     * @notice The current virtual price of the pool LP token
     * @dev Useful for calculating profits.
     *      The method may be vulnerable to donation-style attacks if implementation
     *      contains rebasing tokens. For integrators, caution is advised.
     * @return LP token virtual price normalized to 1e18
     */
    function get_virtual_price() external view returns (uint256);

    /**
     * @notice Calculate addition or reduction in token supply from a deposit or withdrawal
     * @param _amounts Amount of each coin being deposited
     * @param _is_deposit set True for deposits, False for withdrawals
     * @return Expected amount of LP tokens received
     */
    function calc_token_amount(
        uint256[] calldata _amounts,
        bool _is_deposit
    ) external view returns (uint256);

    function A_precise() external view returns (uint256);

    function balances(uint256 i) external view returns (uint256);

    function get_balances() external view returns (uint256[] memory);

    function stored_rates() external view returns (uint256[] memory);

    /**
     *
     * @notice Return the fee for swapping between `i` and `j`
     * @param i Index value for the coin to send
     * @param j Index value of the coin to receive
     * @return Swap fee expressed as an integer with 1e10 precision
     */
    function dynamic_fee(int128 i, int128 j) external view returns (uint256);

    function ramp_A(uint256 _future_A, uint256 _future_time) external;

    function stop_ramp_A() external;

    function set_new_fee(
        uint256 _new_fee,
        uint256 _new_offpeg_fee_multiplier
    ) external;

    function set_ma_exp_time(uint256 _ma_exp_time, uint256 _D_ma_time) external;
}
