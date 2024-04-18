// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;


contract Bank {
    //定义管理员
    address public owner;
    //定义每个账户
    mapping(address => uint) public balances;
    //定义总共的钱
    uint public totalBalance;

    address[3] public top3Depositors;
    uint[3] public top3Amounts;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 1.存款方法，接受一个地址和一个金额作为参数
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;

        //更新前三名
        updateTopThree(msg.sender, msg.value);
    }

    // 2. 管理员取所有钱
    function withdraw() public onlyOwner {
        uint ubalance = address(this).balance;
        require(ubalance > 0, "No balance to withdraw!");

        payable(owner).transfer(totalBalance);

        // 清空 top3Depositors 和 top3Amounts
        delete top3Depositors;
        delete top3Amounts;
    }

    // 3.获取存款金额前三名的信息
    function getTopThree() external view returns (address[3] memory, uint256[3] memory) {
        return (top3Depositors, top3Amounts);
    }

    // 更新存款金额前三名的信息
    function updateTopThree(address account, uint256 amount) internal {
        if (amount > top3Amounts[2]) {
            if (amount > top3Amounts[0]) {
                top3Amounts[2] = top3Amounts[1];
                top3Amounts[1] = top3Amounts[0];
                top3Amounts[0] = amount;

                top3Depositors[2] = top3Depositors[1];
                top3Depositors[1] = top3Depositors[0];
                top3Depositors[0] = account;
            } else if (amount > top3Amounts[1]) {
                top3Amounts[2] = top3Amounts[1];
                top3Amounts[1] = amount;

                top3Depositors[2] = top3Depositors[1];
                top3Depositors[1] = account;
            } else {
                top3Amounts[2] = amount;
                top3Depositors[2] = account;
            }
        }
    }


    // 查询用户存储
    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }

    // 查询银行所有资产
    function getTotalBalance() public view returns (uint) {
        return totalBalance;
    }

}