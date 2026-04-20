 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SoftwareLicense {

    struct Software {
        address owner;
        bytes32 hash;
        bool exists;
    }

    struct License {
        bool approved;
        bool revoked;
        uint64 expiry;
    }

    uint256 public softwareCount;

    mapping(uint256 => Software) public softwares;
    mapping(uint256 => mapping(address => License)) public licenses;
    mapping(uint256 => mapping(address => bool)) public blacklisted;

    // ----------------------------
    // REGISTER SOFTWARE
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
    // REQUEST LICENSE
    // ----------------------------
    function requestLicense(uint256 softwareId) external {
        require(softwares[softwareId].exists, "Software does not exist");
        require(!blacklisted[softwareId][msg.sender], "Blacklisted");

        licenses[softwareId][msg.sender] = License({
            approved: false,
            revoked: false,
            expiry: 0
        });
    }

    // ----------------------------
    // ADMIN APPROVAL
    // ----------------------------
    function approveLicense(
        uint256 softwareId,
        address user,
        uint64 expiry
    ) external {
        require(msg.sender == softwares[softwareId].owner, "Not owner");
        require(!blacklisted[softwareId][user], "Blacklisted");

        licenses[softwareId][user] = License({
            approved: true,
            revoked: false,
            expiry: expiry
        });
    }

    // ----------------------------
    // BLACKLIST (hard revoke)
    // ----------------------------
    function blacklistUser(uint256 softwareId, address user) external {
        require(msg.sender == softwares[softwareId].owner, "Not owner");

        blacklisted[softwareId][user] = true;

        licenses[softwareId][user].approved = false;
        licenses[softwareId][user].revoked = true;
    }

    // ----------------------------
    // SOFT REVOKE
    // ----------------------------
    function revokeLicense(uint256 softwareId, address user) external {
        require(msg.sender == softwares[softwareId].owner, "Not owner");

        licenses[softwareId][user].revoked = true;
    }

    // ----------------------------
    // VERIFY LICENSE (PROOF CHECK)
    // ----------------------------
    function verifyLicense(uint256 softwareId, address user) external view returns (bool) {
        if (blacklisted[softwareId][user]) return false;

        License memory lic = licenses[softwareId][user];

        if (!lic.approved) return false;
        if (lic.revoked) return false;
        if (lic.expiry != 0 && block.timestamp > lic.expiry) return false;

        return true;
    }

    // ----------------------------
    // MESSAGE HASH FOR SIGNING
    // ----------------------------
    function getMessageHash(
        uint256 softwareId,
        address user,
        uint64 expiry
    ) public view returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                "LICENSE",
                softwareId,
                user,
                expiry,
                address(this)
            )
        );
    }
}