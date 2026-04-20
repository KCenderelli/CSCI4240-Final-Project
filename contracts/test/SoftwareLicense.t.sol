 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SoftwareLicense} from "../src/SoftwareLicense.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SoftwareLicenseTest is Test {
    SoftwareLicense license;

    address user = address(1);

    function setUp() public {
        license = new SoftwareLicense();
    }

    // ----------------------------
    // BASIC FLOW TEST
    // ----------------------------
    function testLicenseFlow() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        vm.prank(user);
        license.requestLicense(id);

        license.approveLicense(id, user, uint64(block.timestamp + 1000));

        assertTrue(license.verifyLicense(id, user));

        license.revokeLicense(id, user);

        assertFalse(license.verifyLicense(id, user));
    }

    // ----------------------------
    // BLACKLIST OVERRIDES EVERYTHING
    // ----------------------------
    function testBlacklistOverridesLicense() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        vm.prank(user);
        license.requestLicense(id);

        license.approveLicense(id, user, uint64(block.timestamp + 1000));

        assertTrue(license.verifyLicense(id, user));

        license.blacklistUser(id, user);

        assertFalse(license.verifyLicense(id, user));
    }

    function testBlacklistedCannotRequest() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        license.blacklistUser(id, user);

        vm.prank(user);
        vm.expectRevert("Blacklisted");
        license.requestLicense(id);
    }

    function testBlacklistOverridesRevoke() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        vm.prank(user);
        license.requestLicense(id);

        license.approveLicense(id, user, uint64(block.timestamp + 1000));
        license.revokeLicense(id, user);

        license.blacklistUser(id, user);

        assertFalse(license.verifyLicense(id, user));
    }

    // ----------------------------
    // EXPIRY TEST
    // ----------------------------
    function testLicenseExpires() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        license.approveLicense(id, user, uint64(block.timestamp + 100));

        assertTrue(license.verifyLicense(id, user));

        vm.warp(block.timestamp + 200);

        assertFalse(license.verifyLicense(id, user));
    }

    // ----------------------------
    // BLACKLIST OVERRIDES ALL (REDUNDANT SAFETY CHECK)
    // ----------------------------
    function testBlacklistOverridesAll() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        license.approveLicense(id, user, uint64(block.timestamp + 1000));

        assertTrue(license.verifyLicense(id, user));

        license.blacklistUser(id, user);

        assertFalse(license.verifyLicense(id, user));
    }

    // ----------------------------
    // REVOKE STILL WORKS
    // ----------------------------
    function testRevokeStillWorks() public {
        uint256 id = license.registerSoftware(keccak256("test"));

        license.approveLicense(id, user, uint64(block.timestamp + 1000));

        license.revokeLicense(id, user);

        assertFalse(license.verifyLicense(id, user));
    }
}