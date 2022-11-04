// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Telephone.sol";

contract TelephoneTest is Test {
    Telephone public c;
    address p = address(1337);

    function setUp() public {
        c = new Telephone();
        vm.deal(p, 1 ether);
    }

    /// @dev Claims ownership of the contract
    function testAttack() public {}
}
