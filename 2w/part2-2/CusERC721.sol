// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CusERC721 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721(unicode"open stack", "OS") {}


    // 0x74b73FD5B6A4d5A1Bb63f713997A9CBb1dF54815
    // https://orange-naval-clownfish-219.mypinata.cloud/ipfs/QmVZn4L3VTtQV57CxWhkNbD7mD24QfXsZKvJApEYSxpRVF
    function mint(address me, string memory tokenURI)
    public
    returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(me, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _tokenIds.increment();

        return newItemId;
    }
}