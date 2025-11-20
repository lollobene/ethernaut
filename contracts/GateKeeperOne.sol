
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin, "Sender is origin");
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0, "Gas not modulo 8191");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract GateKeeperOneHelper {

    GatekeeperOne gateKeeper;

    constructor(address gateKeeperOne) {
        gateKeeper = GatekeeperOne(gateKeeperOne);
    }

    function enterGate(uint increment, bytes8 _gateKey) public {
        // increment should be 256
        gateKeeper.enter{gas: 8191 * 4 + increment}(_gateKey);
    }

    function getKey() public view returns (bytes8) {
        bytes8 key = bytes8(uint64(uint160(address(msg.sender)))) & 0xFFFFFFFF0000FFFF;
        return key;
    }
}