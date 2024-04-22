// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract TokenBank {

    string public constant name = "Multi-Token Contract"; // 代币名称
    string public constant symbol = "MTC"; // 代币符号
    uint8 public constant decimals = 18; // 小数位
    uint256 public totalSupply = 100000000 * (10**18); // 数量

    mapping(address => uint256) balances;

    event Deposit(address _addr, uint amount);

    //1存入token
    function deposit(uint amount) public  payable  {
        //存入token
        balances[msg.sender] += (amount*1e18);
        totalSupply += (amount*1e18);
        emit Deposit(msg.sender, amount);
    }


    event Withdraw(address _addr, uint amount);

    //2.获取token
    function withdraw(uint amount) external {
        uint256 hasAmount = balances[msg.sender]/1e18;
        require(hasAmount >= amount, "no token withdraw !");

        balances[msg.sender] -= (amount*1e18);
        emit Withdraw(msg.sender, amount);
    }

    //3.获取token
    function getBalances(address _addr) external returns (uint256 amount) {
        uint256 hasAmount = balances[msg.sender]/1e18;
        return hasAmount;
    }

}