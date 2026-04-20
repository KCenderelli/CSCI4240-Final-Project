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

    // softwareId => Software
    mapping(uint256 => Software) public softwares;

    // softwareId => user => License
    mapping(uint256 => mapping(address => License)) public licenses;

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

        licenses[softwareId][user].approved = true;
        licenses[softwareId][user].revoked = false;
    }

    // ----------------------------
    // Revoke license
    // ----------------------------
    function revokeLicense(uint256 softwareId, address user) external {
        require(msg.sender == softwares[softwareId].owner, "Not owner");

        licenses[softwareId][user].revoked = true;
    }

    // ----------------------------
    // Verify license (public view)
    // ----------------------------
    function verifyLicense(uint256 softwareId, address user) external view returns (bool) {
        License memory lic = licenses[softwareId][user];

        return (lic.approved && !lic.revoked);
    }
}