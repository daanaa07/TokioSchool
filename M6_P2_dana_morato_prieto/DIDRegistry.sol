// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DIDRegistry {
    mapping(string => address) private didToOwner;
    mapping(address => string) private ownerToDID;
    mapping(string => string) public didToData;

    event DIDCreated(string did, string data, address owner);
    event DIDUpdated(string did, string newData);
    event DIDTransferred(string did, address from, address to);

    constructor() {}

    function createDID(string memory did, string memory data) public {
        require(bytes(did).length > 0, "DID cannot be empty");
        require(bytes(data).length > 0, "Data cannot be empty");
        require(didToOwner[did] == address(0), "DID already exists");

        didToOwner[did] = msg.sender;
        ownerToDID[msg.sender] = did;
        didToData[did] = data;

        emit DIDCreated(did, data, msg.sender);
    }

    function updateDID(string memory did, string memory newData) public {
        address owner = didToOwner[did];
        require(owner == msg.sender, "You are not the owner of this DID");

        didToData[did] = newData;
        emit DIDUpdated(did, newData);
    }

    function transferDID(string memory did, address to) public {
        address owner = didToOwner[did];
        require(owner == msg.sender, "You are not the owner of this DID");

        didToOwner[did] = to;
        ownerToDID[msg.sender] = "";
        ownerToDID[to] = did;

        emit DIDTransferred(did, msg.sender, to);
    }

    function resolveDID(string memory did) public view returns (string memory) {
        return didToData[did];
    }
}