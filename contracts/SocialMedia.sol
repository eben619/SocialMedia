// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SocialMedia {
    // Define structure for content
    struct Content {
        uint256 id;
        address creator;
        string contentURI; // URI pointing to the multimedia asset (e.g., IPFS)
        string description;
        uint256 timestamp;
        mapping(uint256 => string) comments;
        uint256 commentsCount;
    }
    struct SearchResult {
        uint256 id;
        address creator;
        string contentURI;
        string description;
        uint256 timestamp;
    }

    // Define user roles
    enum Role {
        User,
        Moderator
    }

    // Mapping to store content
    mapping(uint256 => Content) public content;

    // Mapping to store user roles
    mapping(address => Role) public userRoles;

    // Address of the contract deployer (initially the platform administrator)
    address public admin;

    // Counter for content IDs
    uint256 public contentCount;

    // Events for creating and deleting content
    event ContentCreated(uint256 id, address creator, string contentURI, string description);
    event ContentDeleted(uint256 id);

    // Mapping to store nonce for meta-transactions
    mapping(address => uint256) public nonces;

    // Constructor
    constructor() {
        admin = msg.sender;
        userRoles[msg.sender] = Role.Moderator; // Initially, deployer is a moderator
    }

    // Modifier to restrict functions to specific roles
    modifier onlyRole(Role role) {
        require(userRoles[msg.sender] == role, "Unauthorized access");
        _;
    }

    // Function to create content (mints an NFT representing the content)
    function createContent(string memory contentURI, string memory description) public onlyRole(Role.User) {
        contentCount++;
        Content storage newContent = content[contentCount];
        newContent.id = contentCount;
        newContent.creator = msg.sender;
        newContent.contentURI = contentURI;
        newContent.description = description;
        newContent.timestamp = block.timestamp;
        
        emit ContentCreated(contentCount, msg.sender, contentURI, description);
    }

    // Function to delete content (burns the associated NFT)
    function deleteContent(uint256 id) public onlyRole(Role.Moderator) {
        require(content[id].creator != msg.sender, "Cannot delete own content");
        delete content[id];
        emit ContentDeleted(id);
    }

    // Function to grant/revoke moderator role (restricted to admin)
    function setUserRole(address user, Role role) public onlyRole(Role.Moderator) {
        userRoles[user] = role;
    }

    // Function to get content details
    function getContent(uint256 id) public view returns (uint256, address, string memory, string memory, uint256) {
        Content storage contentItem = content[id];
        return (contentItem.id, contentItem.creator, contentItem.contentURI, contentItem.description, contentItem.timestamp);
    }

    // Function to search content based on keywords in description
    function searchContent(string memory keyword) public view returns (SearchResult[] memory) {
        SearchResult[] memory searchResults = new SearchResult[](contentCount);
        uint256 resultsIndex = 0;
        for (uint256 i = 1; i <= contentCount; i++) {
            Content storage c = content[i];
            if (keccak256(abi.encodePacked(c.description)) == keccak256(abi.encodePacked(keyword))) {
                SearchResult memory result;
                result.id = c.id;
                result.creator = c.creator;
                result.contentURI = c.contentURI;
                result.description = c.description;
                result.timestamp = c.timestamp;
                searchResults[resultsIndex] = result;
                resultsIndex++;
            }
        }
        // Return an array with the found content (adjust size if needed)
        return searchResults;
    }

    // Function to leave a comment on a content (consider access control)
    function commentOnContent(uint256 contentId, string memory comment) public {
        require(contentId <= contentCount, "Invalid content ID");
        content[contentId].comments[content[contentId].commentsCount] = comment;
        content[contentId].commentsCount++;
    }

    // Function to get comments for a specific content
    function getComments(uint256 contentId) public view returns (string[] memory) {
        require(contentId <= contentCount, "Invalid content ID");
        string[] memory comments = new string[](content[contentId].commentsCount);
        for (uint256 i = 0; i < content[contentId].commentsCount; i++) {
            comments[i] = content[contentId].comments[i];
        }
        return comments;
    }

    // Function to create a group
    function createGroup(string memory name) public onlyRole(Role.User) {
        // Implement group creation logic (e.g., using a separate Group contract)
        // ...
    }

    // Function to join a group (consider checking if user is already a member)
    function joinGroup(address groupAddress) public {
        // Implement group joining logic (e.g., calling a function on the Group contract)
        // ...
    }

    // Function to check if a user is a member of a specific group
    function isMemberOfGroup(address user, address groupAddress) public view returns (bool) {
        // Implement logic to check group membership (e.g., using the Group contract)
        // ...
    }

    // Function to perform a meta-transaction
    function metaTransaction(uint256 nonce, bytes memory signature, address destination, uint256 value, bytes memory data) public {
        require(nonce == nonces[msg.sender], "Invalid nonce");
        nonces[msg.sender]++;
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, nonce, destination, value, data));
        require(recoverSigner(hash, signature) == admin, "Signature verification failed");
        (bool success, ) = destination.call{value: value}(data);
        require(success, "Transaction execution failed");
    }

    // Function to recover the signer of a message
    function recoverSigner(bytes32 hash, bytes memory signature) private pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        if (signature.length != 65) {
            return address(0);
        }
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := and(mload(add(signature, 65)), 255)
        }
        if (v < 27) {
            v += 27;
        }
        if (v != 27 && v != 28) {
            return address(0);
        }
        return ecrecover(hash, v, r, s);
    }
}