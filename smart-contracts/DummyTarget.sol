// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DummyTarget {
    uint256 public value;

    function set(uint256 _v) external {
        value = _v;
    }
} 