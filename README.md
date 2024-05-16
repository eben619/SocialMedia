This smart contract implements a basic decentralized social network platform on the Ethereum blockchain. Users can create and share content, search for content based on keywords,

 leave comments, and join groups (group functionality not fully implemented yet). The platform utilizes roles (User and Moderator) to control access to certain actions.

Features:

    Content Creation: Users can create content (think posts) with a description and a URI pointing to the multimedia asset (e.g., stored on IPFS).
    Content Management:
        Users can view content details.
        Users can search for content based on keywords in the description.
        Moderators can delete content created by other users.
    Commenting: Users can leave comments on existing content (access control not yet implemented).
    Group Management (Partially Implemented):
        Users can create groups. (Logic needs to be implemented in a separate contract)
        Users can join existing groups. (Logic needs to be implemented in a separate contract)
        Users can check if they belong to a specific group. (Logic needs to be implemented in a separate contract)
    User Roles:
        Users can be assigned the "User" role by default.
        Moderators can be assigned by the platform administrator (initially the contract deployer) and have additional privileges (e.g., deleting content).
    Meta-Transactions: The contract supports meta-transactions for off-chain signing of transactions, potentially reducing gas costs for users.

Events:

    ContentCreated(uint256 id, address creator, string contentURI, string description): Emitted when a new content item is created.
    ContentDeleted(uint256 id): Emitted when a content item is deleted.

Requirements:

    Solidity compiler version ^0.8.0 (https://docs.soliditylang.org/en/v0.8.19/installing-solidity.html)
    A blockchain development environment (e.g., Remix, Truffle, Hardhat)

Deployment:

    Clone or download this repository.
    Connect your development environment to a blockchain network (e.g., local test network or public network like Ethereum).
    Deploy the SocialMedia contract.
    Interact with the contract functions using your development environment's tools.

License:

MIT License

# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

// SocialMedia deployed to: 0x632395370842E9E19Be0257B5382eF1BeD21930d

https://sepolia.etherscan.io/address/0x632395370842e9e19be0257b5382ef1bed21930d#code
