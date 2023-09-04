//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract MessageCounterBlockchain {
    uint256 public messageCount = 0;

    struct Message {
        address author;
        string content;
        bool read;
    }
    mapping(uint256 => Message) public messages;

    function writeMessage(string memory _content) public payable {
        require(msg.value >= 1 ether, "Insufficient payment");
        messages[messageCount] = Message(msg.sender, _content, false);
        messageCount++;
    }

    function readMessages() public view returns (string[] memory) {
        string[] memory result = new string[](messageCount);
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < messageCount; i++) {
            if (!messages[i].read) {
                result[currentIndex] = messages[i].content;
                currentIndex++;
            }
        }
        return result;
    }

    function markMessageAsRead(uint256 _messageId) public payable returns (bool) {

        uint256 requiredPayment = 0.0000001 ether; 

        require(msg.value >requiredPayment, "Insufficient payment");
        require(msg.value >= 1 ether, "Insufficient payment");
        require(_messageId < messageCount, "Invalid message ID");
        require(messages[_messageId].author == msg.sender, "Only the author can mark a message as read");
        require(!messages[_messageId].read, "Message already marked as read");
        return messages[_messageId].read = true;
    }


    function getMessageAuthor(uint256 _messageId) public view returns (address) {
        require(_messageId < messageCount, "Invalid message ID");
        return messages[_messageId].author;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}