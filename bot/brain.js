const { ethers } = require("ethers");
require("dotenv").config();

// Configuration from your .env
const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
//pm2 stop arb-botconst provider = new ethers.WebSocketProvider(process.env.ALCHEMY_WSS_URL);
const servant = new ethers.Wallet(process.env.SERVANT_PRIVATE_KEY, provider);

// Use the ABI of your FlashTriangle contract (Foundry saves this in out/FlashTriangle.sol/FlashTriangle.json)
const arbAbi = [
    "function startFlashTriangle(address flashPair, uint256 borrowAmount, address dexRouter, address[] calldata path) external"
];
const arbContract = new ethers.Contract(process.env.CONTRACT_ADDRESS, arbAbi, servant);

// Constants for your triangle
const PANCAKE_ROUTER = "0x10ED43C718714eb63d5aA57B78B54704E256024E";
const TOKENS = {
    USDC: "0x8AC76a51cc950d9822D68b83fE1Ad97B44470c99",
    WBNB: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c",
    CAKE: "0x0E09FaF61d2A01ce3950f4748255215613394630"
};
const PATH = [TOKENS.USDC, TOKENS.WBNB, TOKENS.CAKE, TOKENS.USDC];

async function scan() {
    console.log("Scanning BNB Chain via Alchemy WSS...");

    provider.on("block", async (blockNumber) => {
        try {
            // Placeholder: Fetch real-time reserves here
            const prices = await getLiveReserves(); 
            
            // Math: P1 * P2 * P3 * (0.997^3)
            const feeMultiplier = Math.pow(0.997, 3);
            const ratio = prices.p1 * prices.p2 * prices.p3 * feeMultiplier;

            console.log(`Block ${blockNumber} | Ratio: ${ratio.toFixed(5)}`);

            if (ratio > 1.005) { // 0.5% Threshold
                console.log("🚀 Profit Found! Executing...");
                executeTrade();
            }
        } catch (error) {
            console.error("Scan Error:", error.message);
        }
    });
}

async function executeTrade() {
    // Borrow Amount (Example: 1000 USDC)
    const borrowAmount = ethers.parseUnits("1000", 18);
    const flashPair = "0x..."; // The Pair you are borrowing from

    try {
        const tx = await arbContract.startFlashTriangle(
            flashPair, borrowAmount, PANCAKE_ROUTER, PATH
        );
        console.log(`Sent! Hash: ${tx.hash}`);
    } catch (e) {
        console.log("Reverted. $7 gas budget protected.");
    }
}

scan();