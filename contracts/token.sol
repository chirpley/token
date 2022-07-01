// SPDX-License-Identifier: MIT
/**

Chirpley is the world’s first automated, peer-to-peer, all-in-one influencer marketplace
specifically focussed on nano and micro influencers.
Chirpley will provide marketers with the freedom to act fast and effective,
thanks to the possibility of a 1-click marketing bomb.

Website: https://chirpley.ai
App: https://app.chirpley.ai
Discord: https://discord.gg/chirpley
Telegram: https://t.me/chirpley
Twitter: https://twitter.com/chirpley
Youtube: https://www.youtube.com/c/chirpley
Tiktok: https://www.tiktok.com/@chirpley
Instagram: https://www.instagram.com/chirpley/
Facebook: https://www.facebook.com/chirpley
Github: https://github.com/chirpley
**/

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChirpleyToken is ERC20, ERC20Burnable, Ownable {

    string public _name = "Chirpley Token";
    string public _symbol = "CHRP";
    uint8 public _decimals = 18;
    uint256 public _totalSupply = 1 * 10**9 * 10 ** _decimals;
    constructor() ERC20(_name, _symbol) {
        _mint(msg.sender, _totalSupply); 
    }

    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}
