// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CreatorhomeNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;
    string _baseTokenURI;
    uint256 public _price = 0.01 ether;
    bool public _paused;
    uint256 public maxTokenIds = 10;
    uint256 public tokenIds;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract paused");
        _;
    }

    //You can set NFT name and symbol here.
    constructor (string memory baseURI) ERC721("CreatorhomeNFT", "CHN") {
        _baseTokenURI = baseURI;
    }

    function mint() public payable onlyWhenNotPaused {
        require(tokenIds < maxTokenIds, "No more NFT's to mint");
        require(msg.value >= _price, "Not eonugh ether");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "This token not exists.");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Cant send ether");
    }
    receive() external payable {}
    fallback() external payable {}
}