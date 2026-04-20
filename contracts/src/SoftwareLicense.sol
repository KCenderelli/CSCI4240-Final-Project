// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SoftwareLicense {

    struct Software {
        address owner;
        bytes32 hash;
        bool exists;
    }

    struct License {
        bool approved;
        bool revoked;
    }

    uint256 public softwareCount;

    mapping(uint256 => Software) public softwares;
    mapping(uint256 => mapping(address => License)) public licenses;

    // NEW: blacklist per software
    mapping(uint256 => mapping(address => bool)) public blacklisted;

    // ----------------------------
    // Register software
    // ----------------------------
    function registerSoftware(bytes32 hash) external returns (uint256) {
        softwareCount++;

        softwares[softwareCount] = Software({
            owner: msg.sender,
            hash: hash,
            exists: true
        });

        return softwareCount;
    }

    // ----------------------------
    // Request license
    // ----------------------------
    function requestLicense(uint256 softwareId) external {
        require(softwares[softwareId].exists, "Software does not exist");
        require(!blacklisted[softwareId][msg.sender], "User blacklisted");

        licenses[softwareId][msg.sender] = License({
            approved: false,
            revoked: false
        });
    }

    // ----------------------------
    // Approve license
    // ----------------------------
    function approveLicense(uint256 softwareId, address user) external {
        require(msg.sender == softwares[softwareId].owner, "Not owner");
        require(!blacklisted[softwareId][user], "User blacklisted");

        licenses[softwareId][user].approved = true;
        licenses[softwareId][user].revoked = false;
    }

    // ----------------------------
    // Revoke license (soft revoke)
    // ----------------------------
    function revokeLicense(uint256 softwareId, address user) external {
        require(msg.sender == softwares[softwareId].owner, "Not owner");

        licenses[softwareId][user].revoked = true;
    }

    // ----------------------------
    // NEW: blacklist (hard revoke)
    // ----------------------------
    function blacklistUser(uint256 softwareId, address user) external {
        require(msg.sender == softwares[softwareId].owner, "Not owner");

        blacklisted[softwareId][user] = true;

        // also invalidate existing license state
        licenses[softwareId][user].approved = false;
        licenses[softwareId][user].revoked = true;
    }

    // ----------------------------
    // Verify license (PROOF CHECK)
    // ----------------------------
    function verifyLicense(uint256 softwareId, address user) external view returns (bool) {
        if (blacklisted[softwareId][user]) {
            return false;
        }

        License memory lic = licenses[softwareId][user];
        return (lic.approved && !lic.revoked);
    }
}