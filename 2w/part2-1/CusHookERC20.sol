//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IEC20CallBack.sol";

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}

contract CusHookERC20 is ERC20 {

    using Address for address;

    event TransferWithCallback(address from,address to, uint256 amount);

    constructor() ERC20("openspace", "OS") {
        _mint(msg.sender, 10000000* 10 ** 18);
    }

    //recipient  自定义bank的合约地址
    function transferWithCallback(address recipient, uint256 amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        emit TransferWithCallback(msg.sender, recipient, amount);
        if (recipient.isContract()) {
            bool rv = IEC20CallBack(recipient).tokensReceived(msg.sender, amount, 0);
            require(rv, "No tokensReceived");
        }
        return true;
    }

    //recipient  自定义NFT的合约地址
    function transferWithCallback(address recipient, uint256 amount, uint tokenId) external returns (bool) {
        emit TransferWithCallback(msg.sender, recipient, amount);
        if (recipient.isContract()) {
            bool rv = IEC20CallBack(recipient).tokensReceived(msg.sender, amount, tokenId);
            require(rv, "No tokensReceived");
        }
        return true;
    }

}