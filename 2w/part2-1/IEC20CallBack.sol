// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;


interface IEC20CallBack {

    function tokensReceived(address sender, uint amount, uint tokenId) external returns (bool);
    
}