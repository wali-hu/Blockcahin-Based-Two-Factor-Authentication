// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {TwoFactorAuth} from "../src/TwoFactorAuth.sol";

contract DeployTwoFactorAuth is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the TwoFactorAuth contract
        TwoFactorAuth twoFactorAuth = new TwoFactorAuth();

        // Log the address of the deployed contract
        console.log("TwoFactorAuth deployed at:", address(twoFactorAuth));

        vm.stopBroadcast();
    }
}
