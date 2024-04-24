// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CusERC20 is ERC20 {

    address public owner;

    mapping(address account => uint256) private _balances;

    constructor() ERC20("OpenSea", "OS") {
        // 将所有供应的token转入合约创建者的账户余额
        _mint(msg.sender, 10000 * 10 ** 18);
    }

    //查看是否是合约地址
    function isContract(address _addr) public  view returns (bool) {
        uint256 size;
        //合约内部操作
        assembly{
            size := extcodesize(_addr)
        }
        return size > 0;
    }

}