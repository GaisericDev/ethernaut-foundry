// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Reentrancy.sol";

contract ReentrancyTest is Test {
    Reentrance public c;
    Attack public a;
    address p = address(1337);

    function setUp() public {}

    // https://blog.dixitaditya.com/ethernaut-level-10-re-entrancy
    /// @dev Steal all the funds from the contract
    function testAttack() public {
        vm.startPrank(p);
        vm.stopPrank();
    }
}
