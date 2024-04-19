// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

import "./Bank.sol";
import "./Ownable.sol";

contract BigBank is Bank {

    //1.转移管理员权限给合约地址
    function transferOwn() external onlyOwner {
        Ownable ownable = new Ownable();
        owner = address(ownable);
    }

    //2.存钱限制
    function deposit() public payable override {
        require(msg.value >= 0.001 ether, "Deposit amount must be greater than or equal to 0.001 ether");
        balances[msg.sender] += msg.value;
    }

}