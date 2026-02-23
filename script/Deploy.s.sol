// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {FlashTriangle} from "../src/FlashTriangle.sol";

contract DeployFlashTriangle is Script {
    function run() external {
        // Load variables from .env
        uint256 deployerPrivateKey = vm.envUint("SERVANT_PRIVATE_KEY");
        address servant = vm.envAddress("SERVANT_ADDRESS");
        address boss = vm.envAddress("BOSS_ADDRESS");

        // Start broadcasting transactions to the RPC
        vm.startBroadcast(deployerPrivateKey);

        // Deploy with the two-address constructor
        new FlashTriangle(servant, boss);

        vm.stopBroadcast();
    }
}
