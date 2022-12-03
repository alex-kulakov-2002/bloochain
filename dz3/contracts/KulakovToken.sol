// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KulakovToken is ERC20, Ownable {
    constructor() ERC20("KulakovToken", "KUT") {
        _mint(msg.sender, 200000 * 10**decimals());
    }

    function createKey() public view returns (string memory) {
        return "myKey";
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
