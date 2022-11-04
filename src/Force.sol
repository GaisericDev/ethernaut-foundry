// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Force {
    /*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/
}

contract Destroyer {
    function byebye(address payable _target) public {
        selfdestruct(_target);
    }

    fallback() external {}

    receive() external payable {}
}
