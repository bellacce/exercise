// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
    使用自己的发行的 Token 来买卖 NFT， 函数的方法有：
    list() : 实现上架功能，NFT 持有者可以设定一个价格（需要多少个 Token 购买该 NFT）并上架 NFT 到 NFT 市场。
    buyNFT() : 实现购买 NFT 功能，用户转入所定价的 token 数量，获得对应的 NFT。
*/
contract NFTMarket is IERC721Receiver {

	//nft 持有人
	mapping(uint256 nftId => address account) public tokenHolder;
	//NFT 价格的amount
	mapping(uint256 nftId => uint256 amount) public  tokenIdPrice;

	address public token;
	address public nftToken;

	/*
        _token: ERC20 合约地址
        _nftToken: ERC721 合约地址
    */
	constructor(address _token, address _nftToken) {
		token = _token;
		nftToken = _nftToken;
	}

	// event ERC721Received(address operator,address from,  uint256 tokenId, bytes data);

	function onERC721Received(address , address , uint256 ,  bytes calldata) public pure  override  returns (bytes4) {
		return this.onERC721Received.selector;
	}

	event Log(address from,address to, uint tokenId);
	//1.先上架
	function list(uint256 tokenId, uint256 amount) public  {
		emit Log(msg.sender, address(this), tokenId);
		IERC721(nftToken).safeTransferFrom(msg.sender, address(this), tokenId, "");
		tokenIdPrice[tokenId] = amount;
		tokenHolder[tokenId] = msg.sender;
	}

	//2.在购买,
	function buyNFT(uint tokenId, uint amount) external {
		//判断token（代币）是否够用
		require(amount >= tokenIdPrice[tokenId], "no enough token to pay!");

		//只有把nftToken挂在NFT市场上，才可以卖
		require(IERC721(nftToken).ownerOf(tokenId) == address(this), "aleady selled");

		//ERC20转账，授权NFTMarket合约去操作，获取NFT的token数量，转移token到卖家名下
		IERC20(token).transferFrom(msg.sender, tokenHolder[tokenId], tokenIdPrice[tokenId]);
		//ERC721，授权NFTMarket合约去操作，把NFT转移到发送者名下
		IERC721(nftToken).transferFrom(address(this), msg.sender, tokenId);
	}


}