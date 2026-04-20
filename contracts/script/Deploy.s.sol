// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import "forge-std/Script.sol";
// import "forge-std/console.sol";
// import "../src/SoftwareLicense.sol";


import {SoftwareLicense} from "../src/SoftwareLicense.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        SoftwareLicense license = new SoftwareLicense();

        console.log("SoftwareLicense deployed at:", address(license));

        vm.stopBroadcast();
    }
}