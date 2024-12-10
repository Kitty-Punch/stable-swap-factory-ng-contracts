# List of Scripts

## RPCs

Mainnet: https://mainnet.evm.nodes.onflow.org
Testnet: https://testnet.evm.nodes.onflow.org

## Scripts

### Deploy StableKittySwapNGMath

forge script ./script/01_StableKittySwapNGMathDeploy.s.sol:StableKittySwapNGMathDeployScript --rpc-url <rpc-url> -vvv --broadcast

### Deploy StableKittySwapNGViews

forge script ./script/02_StableKittySwapNGViewsDeploy.s.sol:StableKittySwapNGViewsDeployScript --rpc-url <rpc-url> -vvv --broadcast

### Deploy StableKittySwapNG

forge script ./script/03_StableKittySwapNGDeploy.s.sol:StableKittySwapNGDeployScript --rpc-url <rpc-url> -vvv --broadcast

### Deploy StableKittySwapMetaNG

forge script ./script/04_StableKittySwapMetaNGDeploy.s.sol:StableKittySwapMetaNGDeployScript --rpc-url <rpc-url> -vvv --broadcast

### Deploy StableKittyFactoryNG

forge script ./script/05_StableKittyFactoryNGDeploy.s.sol:StableKittyFactoryNGDeployScript --rpc-url <rpc-url> -vvv --broadcast

### Set StableKittyFactoryNG Implementations

forge script ./script/06_StableKittyFactoryNGSetImplementations.s.sol:StableKittyFactoryNGSetImplementationsScript --rpc-url <rpc-url> -vvv --legacy --slow --broadcast

### Deploy Pool

forge script ./script/07_StableKittyFactoryNGDeployPlainPool.s.sol:StableKittyFactoryNGDeployPlainPoolScript --rpc-url <rpc-url> -vvv --legacy --slow --broadcast

### Add Liquidity

forge script ./script/08_StableKittyFactoryNGAddLiquidity.s.sol:StableKittyFactoryNGAddLiquidityScript --rpc-url <rpc-url> -vvv --legacy --slow --broadcast

### Deploy KittyRouterNgPoolsOnly

forge script ./script/09_KittyRouterNgPoolsOnlyDeploy.s.sol:KittyRouterNgPoolsOnlyDeployScript --rpc-url <rpc-url> -vvv --broadcast
