// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;



struct Stats {
    uint level;
    uint speed;
    uint strength;
    uint life;

}

    mapping(uint256 => Stats) public tokenIdToLevels;


 

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function generateCharacter(uint256 tokenId) public returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevel(tokenId),'</text>',
             "<text x='50%' y='80%' class='base' dominant-baseline='middle' text-anchor='middle'>Speed:",getSpeed(tokenId)," km/h</text>",
              "<text x='50%' y='70%' class='base' dominant-baseline='middle' text-anchor='middle'>Strength:",getStrength(tokenId)," pascal</text>",
            "<text x='50%' y='60%' class='base' dominant-baseline='middle' text-anchor='middle'>HP:",getLife(tokenId),"</text>",
           
           
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ))
            ;
    }

function getLevel(uint256 tokenId) public view returns (string memory) {
    uint256 level = tokenIdToLevels[tokenId].level;
    return level.toString();
}
 
    function getLife(uint256 tokenId) public view returns(string memory) {
        uint256 life = tokenIdToLevels[tokenId].life;
        return life.toString();
    }

  function getStrength(uint256 tokenId) public view returns(string memory) {
      uint256 strength =  tokenIdToLevels[tokenId].strength;
        return strength.toString();
    }

  function getSpeed(uint256 tokenId) public view returns(string memory) {
uint256 speed = tokenIdToLevels[tokenId].speed;
        return speed.toString();
    }


function getTokenURI(uint256 tokenId) public returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }



  function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId].level = 6;
        tokenIdToLevels[newItemId].speed = 66;
        tokenIdToLevels[newItemId].strength = 666;
        tokenIdToLevels[newItemId].life = 6666;
           _setTokenURI(newItemId, getTokenURI(newItemId));
    }


    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        uint256 currentLevel = tokenIdToLevels[tokenId].level;
        tokenIdToLevels[tokenId].level = currentLevel + random(currentLevel);

        uint256 currentSpeed = tokenIdToLevels[tokenId].speed;
        tokenIdToLevels[tokenId].speed = currentSpeed + random(currentSpeed);

        uint256 currentStrength = tokenIdToLevels[tokenId].strength;
        tokenIdToLevels[tokenId].strength = currentStrength + random(currentStrength);

        uint256 currentLife = tokenIdToLevels[tokenId].life;
        tokenIdToLevels[tokenId].life = currentLife + random(currentLife);

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

        function random(uint256 number) public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender))) % number;
    }
}


