// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

import "./Bank.sol";
import "./Ownable.sol";


interface IBank {
    function withdraw(address _addr, uint amount) external;
}

contract BigBank is Bank {

    modifier validDeposit(){
        require(msg.value > 0.001 ether, "Deposit amount must be greater than or equal to 0.001 ether");
        _;
    }

    //1.存钱限制
    function deposit() public override payable validDeposit {
        super.deposit();
    }


    //2.权限转移
    function authTransfer(address _address) external onlyOwner {
        owner = _address;
    }

    //3.取钱 amount
    function withdraw(address _addr, uint amount) public override onlyOwner{
        uint totalMoney = balances[msg.sender] ;
        require(amount > totalMoney, "no enough money to withdraw");
        balances[_addr] -= amount;
        payable(_addr).transfer(amount);
    }

}