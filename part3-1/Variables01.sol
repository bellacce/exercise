// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Variables {
    // State Variables

    int256 public myInt = 1;
    uint256 public myUint256 = 1;
    uint8 public myUint8 = 1;

    string public myString = "Hello, World!";
    bytes32 public myBytes32 = "Hello, World!";

    address public myAddress = 0x2F77b48e65498E18434825184D8c7635cEaf2975;

    struct MyStruct {
        uint256 myUint256;
        string myString;
    }

    MyStruct public myStruct = MyStruct(1, "Hello, World!");

    // Local Variables
    function getValue() public pure returns (uint256) {
        uint256 value = 1;
        return value;
    }
}