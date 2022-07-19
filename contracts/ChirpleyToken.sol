// SPDX-License-Identifier: MIT
/**
Chirpley is the world’s first automated, peer-to-peer, all-in-one influencer marketplace
specifically focussed on nano and micro influencers.
Chirpley will provide marketers with the freedom to act fast and effective,
thanks to the possibility of a 1-click marketing bomb.

Website: https://chirpley.ai
App: https://app.chirpley.ai
Gitbook: https://chirpley.gitbook.io
Github: https://github.com/chirpley
Medium: https://chirpley.medium.com
Telegram: https://t.me/chirpley
Twitter: https://twitter.com/chirpley
Discord: https://discord.gg/chirpley
Youtube: https://www.youtube.com/c/chirpley
Tiktok: https://www.tiktok.com/@chirpley
Instagram: https://www.instagram.com/chirpley/
Facebook: https://www.facebook.com/chirpley

**/

pragma solidity ^0.8.13;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

interface IAntisnipe {
    function assureCanTransfer(
        address sender,
        address from,
        address to,
        uint256 amount
    ) external;
}

contract ChirpleyToken is ERC20, ERC20Burnable, Ownable {
    string public constant _name = 'CToken';
    string public constant _symbol = 'CRP';
    uint8 public constant _decimals = 18;
    uint256 public constant _totalSupply = 1 * 10**9 * 10**_decimals;
    IAntisnipe public antisnipe = IAntisnipe(address(0));
    bool public antisnipeDisable;

    constructor() ERC20(_name, _symbol) {
        _mint(msg.sender, _totalSupply);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (from == address(0) || to == address(0)) return;
        if (!antisnipeDisable && address(antisnipe) != address(0))
            antisnipe.assureCanTransfer(msg.sender, from, to, amount);
    }

    function setAntisnipeDisable() external onlyOwner {
        require(!antisnipeDisable);
        antisnipeDisable = true;
    }

    function setAntisnipeAddress(address addr) external onlyOwner {
        antisnipe = IAntisnipe(addr);
    }
    
}
