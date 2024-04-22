// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "./BaseERC20.sol";

contract TokenBank is BaseERC20 {

    string public constant name = "Multi-Token Contract"; // 代币名称
    string public constant symbol = "MTC"; // 代币符号
    uint8 public constant decimals = 18; // 小数位

    uint256 public constant INITIAL_SUPPLY = 100000000 ether; // 数量

    constructor() {
        //定义token总数, 给当前合约
        balances[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
    }

    //1.先授权用户token数量
    function approve(address _spender, uint256 _value) public override returns (bool success) {
        require(balances[msg.sender] > _value, "no token to approve !");
        mapping(address => uint256) storage cusMap = allowances[msg.sender];
        cusMap[_spender] += _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    //2.存入token到银行账户
    function deposit(address _from, address _to, uint256 _value) public  payable  {
        require(balances[_from] >= _value, "transfer amount exceeds balance");
        require(allowances[_from][_to] >= _value, "transfer amount exceeds allowance");

        //存入token
        balances[_from] -= _value;
        balances[_to] += _value;

        //减掉授权的金额
        allowances[_from][_to] -= _value;
        emit Transfer(_from, _to, _value);
    }

    //3. 用户可以提取自己的之前存入的 token
    function withdraw(address _from, address _to, uint256 _value) external {
        require(balances[_from] >= _value, "no token withdraw !");
        balances[_from] -= _value;
        emit Transfer(_from, _to, _value);
    }

}