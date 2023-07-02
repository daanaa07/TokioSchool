// SPDX-License-Identifier: GPL-3.0

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

contract MessagingApp {
    struct Message {
        string content;
        address author;
        bool read;
        uint256 amount;
    }

    mapping(uint256 => Message) public messages;
    uint256 public messageCount;

    event MessageSent(
        uint256 messageId,
        string content,
        address author,
        uint256 amount
    );

function writeMessage(string memory _content, uint256 _amount) public payable {
    
        require(msg.value >= 3 , "Insufficient payment");
        require(bytes(_content).length <= 300, "Message exceeds maximum length");
        
        messages[messageCount] = Message({
            content: _content,
            author: msg.sender,
            read: false,
            amount: _amount
        });
        
        emit MessageSent(messageCount, _content, msg.sender, _amount);
        
        if (msg.value > _amount) {
            uint256 refundAmount = msg.value - _amount;
            payable(msg.sender).transfer(refundAmount);
        }
        
        messageCount++;
    }
    
    function readMessages(uint256 _amount) public payable returns (string[] memory) {
        require(msg.value >= 3, "Insufficient payment");
        
        string[] memory result = new string[](messageCount);
        
        for (uint256 i = 0; i < messageCount; i++) {
            result[i] = messages[i].content;
        }
        
        if (msg.value > 3 ) {
            uint256 refundAmount = msg.value - 3 ;
            payable(msg.sender).transfer(refundAmount);
        }
        
        return result;
    }
    
    function readUnreadMessages(uint256 _amount) public payable returns (string[] memory) {
        require(msg.value >= 2, "Insufficient payment");
        
        uint256 unreadCount = 0;
        
        for (uint256 i = 0; i < messageCount; i++) {
            if (!messages[i].read) {
                unreadCount++;
            }
        }
        
        string[] memory result = new string[](unreadCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < messageCount; i++) {
            if (!messages[i].read) {
                result[currentIndex] = messages[i].content;
                currentIndex++;
            }
        }
        
        if (msg.value > 2) {
            uint256 refundAmount = msg.value - 2;
            payable(msg.sender).transfer(refundAmount);
        }
        
        return result;
    }
    
    function markMessageAsRead(uint256 _messageId, uint256 _amount) public payable {
        require(_messageId < messageCount, "Invalid message ID");
        require(messages[_messageId].author == msg.sender, "Only the author can mark a message as read");
        require(!messages[_messageId].read, "Message already marked as read");
        require(msg.value >= 5 , "Insufficient payment");
        
        messages[_messageId].read = true;
        
        if (msg.value > 5 ) {
            uint256 refundAmount = msg.value - 5;
            payable(msg.sender).transfer(refundAmount);
        }
    }
    
    function getMessageAuthor(uint256 _messageId, uint256 _amount) public payable returns (address) {
        require(_messageId < messageCount, "Invalid message ID");
        require(msg.value >= 3, "Insufficient payment");
        
        if (msg.value > 3) {
            uint256 refundAmount = msg.value - 3;
            payable(msg.sender).transfer(refundAmount);
        }
        
        return messages[_messageId].author;
    }

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }
}
