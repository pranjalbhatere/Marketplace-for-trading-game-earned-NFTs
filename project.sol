// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GameNFTMarketplace {
    struct NFT {
        uint256 id;
        address payable owner;
        uint256 price;
        bool forSale;
    }

    mapping(uint256 => NFT) public nfts;
    uint256 public nftCount;

    event NFTListed(uint256 id, address owner, uint256 price);
    event NFTBought(uint256 id, address buyer, uint256 price);
    event NFTDelisted(uint256 id, address owner);

    modifier onlyOwner(uint256 _nftId) {
        require(nfts[_nftId].owner == msg.sender, "Not the owner");
        _;
    }

    function listNFT(uint256 _id, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");
        nfts[_id] = NFT(_id, payable(msg.sender), _price, true);
        nftCount++;

        emit NFTListed(_id, msg.sender, _price);
    }

    function buyNFT(uint256 _id) public payable {
        NFT storage nft = nfts[_id];
        require(nft.forSale, "NFT not for sale");
        require(msg.value == nft.price, "Incorrect price");

        address payable previousOwner = nft.owner;
        nft.owner = payable(msg.sender);
        nft.forSale = false;

        previousOwner.transfer(msg.value);

        emit NFTBought(_id, msg.sender, nft.price);
    }

    function delistNFT(uint256 _id) public onlyOwner(_id) {
        nfts[_id].forSale = false;

        emit NFTDelisted(_id, msg.sender);
    }

    function updatePrice(uint256 _id, uint256 _newPrice) public onlyOwner(_id) {
        require(_newPrice > 0, "Price must be greater than zero");
        nfts[_id].price = _newPrice;
    }
}

