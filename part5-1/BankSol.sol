// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;


contract Bank {
    //定义管理员
    address public owner;
    //定义每个账户
    mapping(address => uint) public balances;
    //定义top3存款人
    address[3] private top3Depositors;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 1.存款方法
    function deposit() public virtual payable {
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
    function withdraw() external onlyOwner {
        uint ubalance = address(this).balance;
        require(ubalance > 0, "No balance to withdraw!");
        payable(owner).transfer(ubalance);
    }

    //3. 个人取钱
    function withdraw(address _addr, uint amount) public virtual  onlyOwner{
        require(balances[_addr] >= amount, "No balance to withdraw!");
        balances[_addr] -= amount;
        payable(_addr).transfer(amount);
    }

    function getTop3() external view returns (address[3] memory) {
        return top3Depositors;
    }

    receive() external virtual payable {
        deposit();
    }

    fallback() external payable { }

}