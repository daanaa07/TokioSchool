// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MessagingApp {
    struct Message {
        string content;
        address author;
        bool read;
    }
    
    mapping(uint256 => Message) public messages;
    uint256 public messageCount;
    
    event MessageSent(uint256 messageId, string content, address author);
    
    function writeMessage(string memory _content) public {
        require(bytes(_content).length <= 300, "Message exceeds maximum length");
        
        messages[messageCount] = Message({
            content: _content,
            author: msg.sender,
            read: false
        });
        
        emit MessageSent(messageCount, _content, msg.sender);
        
        messageCount++;
    }
    
    function readMessages() public view returns (string[] memory) {
        string[] memory result = new string[](messageCount);
        
        for (uint256 i = 0; i < messageCount; i++) {
            result[i] = messages[i].content;
        }
        
        return result;
    }
    
    function readUnreadMessages() public view returns (string[] memory) {
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
        
        return result;
    }
    
    function markMessageAsRead(uint256 _messageId) public {
        require(_messageId < messageCount, "Invalid message ID");
        require(messages[_messageId].author == msg.sender, "Only the author can mark a message as read");
        require(!messages[_messageId].read, "Message already marked as read");
        
        messages[_messageId].read = true;
    }
    
    function getMessageAuthor(uint256 _messageId) public view returns (address) {
        require(_messageId < messageCount, "Invalid message ID");
        
        return messages[_messageId].author;
    }
}
