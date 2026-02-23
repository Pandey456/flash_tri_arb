// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Minimal Interfaces for gas efficiency
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

interface IUniswapV2Pair {
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
}

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

contract FlashTriangle {
    address public immutable boss;
    address public immutable servant;

    constructor(address _servant, address _boss) {
        boss = _boss;
        servant = _servant;
    }

    // 1. The Servant triggers this
    function startFlashTriangle(
        address flashPair,
        uint256 borrowAmount,
        address dexRouter,
        address[] calldata path // [USDC, WBNB, CAKE, USDC]
    ) external {
        require(msg.sender == servant, "Only Servant");

        // Data to pass to the callback
        bytes memory data = abi.encode(dexRouter, path, borrowAmount);

        // Assuming we borrow token0. Logic adjusts in callback.
        IUniswapV2Pair(flashPair).swap(borrowAmount, 0, address(this), data);
    }

    // 2. The Callback (PancakeSwap/Uniswap calls this)
    function pancakeCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external {
        (address router, address[] memory path, uint256 borrowAmount) = abi
            .decode(data, (address, address[], uint256));

        uint256 amountIn = amount0 > 0 ? amount0 : amount1;

        // A. Execution: Trade the borrowed money in a triangle
        IERC20(path[0]).approve(router, amountIn);
        IUniswapV2Router(router).swapExactTokensForTokens(
            amountIn,
            0,
            path,
            address(this),
            block.timestamp
        );

        // B. Repayment Calculation (0.3% fee)
        uint256 fee = ((amountIn * 3) / 997) + 1;
        uint256 amountToRepay = amountIn + fee;

        // C. Repay & Send Profit to Boss
        IERC20(path[0]).transfer(msg.sender, amountToRepay);

        uint256 profit = IERC20(path[0]).balanceOf(address(this));
        require(profit > 0, "No profit to cover gas");
        IERC20(path[0]).transfer(boss, profit);
    }
}
