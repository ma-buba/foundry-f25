//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {fundme} from "../../src/fundme.sol";
import {Deployfundme} from "../../script/Deployfundme.s.sol";
import {Fundfundme} from "../../script/interaction.s.sol";
import {WithdrawFundme} from "../../script/interaction.s.sol";

contract Interactiontest is Test{

    fundme fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external{
        Deployfundme deploy = new Deployfundme();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testusercanfundinteractions() public{
        Fundfundme fundFundme = new Fundfundme();
        vm.prank(USER);
        vm.deal(USER, 11e18);
        fundFundme.fundfundme(address(fundMe));
        WithdrawFundme withdrawfundme = new WithdrawFundme();
        withdrawfundme.Withdrawfundme(address(fundMe));
        assert(address(fundMe).balance == 0);
        address funder = fundMe.getfunder(0);
        assertEq(funder, USER);

    }




}