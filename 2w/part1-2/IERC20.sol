// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract TokenBank{

    ERC20 public token;
    mapping(address => uint256) public balanceOf;


    event Deposit(address indexed _address,uint256 _amount);
    event Withdraw(address indexed _address,uint256 _amount);

    //初始化获取ERC20地址
    constructor(ERC20 _token){
        token = _token;
    }

    //1.存入token
    function deposit(uint256 _amount) external {
        //开通bank在ERC20的账户, 授权用户的token(来自于初始化合约的token)，并把一部分token转移到bank地址
        token.transferFrom(msg.sender, address(this), _amount);
        //bank记录资金池
        balanceOf[msg.sender] += _amount;
        emit Deposit(msg.sender, _amount);
    }

    //2.获取token
    function withdraw(uint256  tokenAmount) external{
        uint256 _amount = balanceOf[msg.sender];
        require(_amount > tokenAmount, "too many token to withdraw!");
        balanceOf[msg.sender] = 0;
        //资金转移
        token.transfer(msg.sender, tokenAmount);
        emit Withdraw(msg.sender, tokenAmount);
    }



}