// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/King.sol";

contract KingTest is Test {
    King public c;
    address p = address(1337);
    address p2 = address(1338);

    function setUp() public {
        vm.deal(p, 2 ether);
        vm.deal(p2, 10 ether);
        c = new King();
    }

    /// @dev Become king and prevent anyone else from becoming king
    function testAttack() public {
        vm.prank(p);
        (bool sent, ) = address(c).call{value: 1 * 1 ether}("");
        vm.prank(p2);
        (bool sent2, ) = address(c).call{value: 2 * 1 ether}("");
        console.log(address(c).balance);
        /// @dev check that the king p2 attempt reverted with the message from the malicious king contract
    }
}
