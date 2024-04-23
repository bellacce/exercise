//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}

interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

contract MyERC20Callback is ERC20 {

    using Address for address;

    event TransferWithCallback(address from,address to, uint256 amount);

    constructor() ERC20("openspace", "OS") {
        _mint(msg.sender, 10000000* 10 ** 18);
    }

    function transferWithCallback(address recipient, uint256 amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        emit TransferWithCallback(msg.sender, recipient, amount);
        if (recipient.isContract()) {
            bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount);
            require(rv, "No tokensReceived");
        }
        return true;
    }


}