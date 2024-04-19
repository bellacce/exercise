// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;


contract Bank {
    //定义管理员
    address public owner;
    //定义每个账户
    mapping(address => uint) public balances;
    //定义top3存款人
    address[3] public top3Depositors;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 1.存款方法
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        if(balances[msg.sender] > balances[top3Depositors[2]]){
            if (balances[msg.sender] >  balances[top3Depositors[0]]) {
                top3Depositors[2] = top3Depositors[1];
                top3Depositors[1] = top3Depositors[0];
                top3Depositors[0] = msg.sender;
            } else if (balances[msg.sender] > balances[top3Depositors[1]]){
                top3Depositors[2] = top3Depositors[1];
                top3Depositors[1] = msg.sender;
            } else {
                top3Depositors[2] = msg.sender;
            }
        }
    }

    // 2. 管理员取所有钱
    function withdraw() public onlyOwner {
        uint ubalance = address(this).balance;
        require(ubalance > 0, "No balance to withdraw!");
        payable(owner).transfer(ubalance);
    }

    function getTop3() external view returns (address[3] memory) {
        return top3Depositors;
    }

    //收钱回调
    receive() external payable { }

    //没有function的方法会调用
    fallback() external payable { }

    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }

    // 查询银行所有资产
    function getTotalBalance() public view returns (uint) {
        return address(this).balance;
    }

}