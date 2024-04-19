// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;

contract Ownable {

    function getExtAddress() public view returns (address) {
        return address(this);
    }
}