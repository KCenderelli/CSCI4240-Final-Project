// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import "forge-std/Test.sol";
// import "../src/SoftwareLicense.sol";

import {SoftwareLicense} from "../src/SoftwareLicense.sol";
import {Test} from "forge-std/Test.sol";

contract SoftwareLicenseTest is Test {
    SoftwareLicense license;

    address user = address(1);

    function setUp() public {
        license = new SoftwareLicense();
    }

    function testLicenseFlow() public {
        bytes32 hash = keccak256(abi.encodePacked("test"));

        uint256 id = license.registerSoftware(hash);

        vm.prank(user);
        license.requestLicense(id);

        license.approveLicense(id, user);

        bool valid = license.verifyLicense(id, user);
        assertTrue(valid);

        license.revokeLicense(id, user);

        valid = license.verifyLicense(id, user);
        assertFalse(valid);
    }
}