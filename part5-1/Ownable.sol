// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

import "./BigBank.sol";



contract Ownable {

    event Received(address from, address to, uint amount);

    receive() external payable {
        emit Received(msg.sender, address(this), msg.value);
    }

    function withdraw(address payable bank, address _addr, uint amount) external  {
        IBank(bank).withdraw(_addr, amount);
    }

    function getBalance(address _addr) public view returns (uint){
        return address(_addr).balance;
    }

}