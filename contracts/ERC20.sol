/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyToken is ERC20, AccessControl {
    uint private immutable MAX_SUPPLY = 2100000 * (10 ** 18);
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("HKToken", "HKT") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function addMinter(address account) public virtual {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Sender must be owner");
        grantRole(MINTER_ROLE, account);
    }

    function mint(address to, uint256 amount) external returns (bool) {
        require(hasRole(MINTER_ROLE, msg.sender), "UNAUTHORIZED SENDER");
        require(totalSupply() + amount < MAX_SUPPLY, "TOKEN_AMOUNT_GREATER_THAN_MAX_SUPPLY");
        _mint(to, amount);
        return true;
    }
}
