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

    function testBlacklistOverridesLicense() public {
        bytes32 hash = keccak256(abi.encodePacked("test"));
        uint256 id = license.registerSoftware(hash);

        vm.prank(user);
        license.requestLicense(id);

        license.approveLicense(id, user);

        // should be valid first
        assertTrue(license.verifyLicense(id, user));

        // now blacklist user
        license.blacklistUser(id, user);

        // should FAIL even though previously approved
        assertFalse(license.verifyLicense(id, user));
    }

    function testBlacklistedCannotRequest() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        license.blacklistUser(id, user);

        vm.prank(user);
        vm.expectRevert("User blacklisted");
        license.requestLicense(id);
    }

    function testBlacklistOverridesRevoke() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        vm.prank(user);
        license.requestLicense(id);

        license.approveLicense(id, user);
        license.revokeLicense(id, user);

        license.blacklistUser(id, user);

        assertFalse(license.verifyLicense(id, user));
    }
}