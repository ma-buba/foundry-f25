//SPDX-License-Identifier:MIT 
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {fundme} from "../../src/fundme.sol";
import {Deployfundme} from "../../script/Deployfundme.s.sol";

contract fundmeTest is Test {
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;//1e17
    uint256 constant STARTING_BALANCE = 10 ether;//10e18
    //uint256 number = 1;

    // function setUp() external {
    //     number = 2;
    // }

    // function testDemo() public {
    //     console.log(number);
    //     console.log("hi mom");
    //     assertEq(number, 2);
    // }

    // function testFundMe() public {
    //     fundme fm = new fundme();
    //     console.log(fm.MINIMUM_USD());
    // }    
    fundme Fundme;
    function setUp() external {
        //Fundme = new fundme(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        Deployfundme deployfundme = new Deployfundme();
        Fundme = deployfundme.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testminimumUSD() public view {
        //assertEq(Fundme.MINIMUM_USD(), 5e18);
        console.log(Fundme.MINIMUM_USD());
    }

    function testownerismsgsender() public view {
        assertEq(Fundme.getowner(), msg.sender);
        console.log(address(this));
    }

    function testpricefeedversionisAccurate() public view {
        uint256 version = Fundme.getVersion();
        assertEq(version, 4);
        //console.log(version);
    }

    function testfundfailswithoutenoughEth() public {
	vm.expectRevert();
	Fundme.fund();
    }

    function testfundupdatesfundeddataStructure() public {
        vm.prank(USER);
        Fundme.fund{value:SEND_VALUE}();
        //we check if address to amount funded is getting updated 
        //we gonna do some refactoring for storage variables (add "s")
        uint256 amountfunded = Fundme.getAddresstoAmountfunded(USER);
        assertEq(amountfunded, SEND_VALUE);
    }

    function testAddsfundertoArrayofFunders() public {
        vm.prank(USER);
        Fundme.fund{value:SEND_VALUE}();
        address funders = Fundme.getfunder(0);
        assertEq(funders, USER);
    }

    modifier funded() {
        vm.prank(USER);
        Fundme.fund{value:SEND_VALUE}();
        _;
    }

    function testonlyownercanwithdraw() public  funded{
        vm.expectRevert();
        vm.prank(USER);
        Fundme.withdraw();
    }

    function testwithdrawwithASingleFunder() public funded{
        //Arrange
        uint256 startingownerbalance = Fundme.getowner().balance;
        uint256 startingfundmeBalance = address(Fundme).balance;
        //Act
        vm.prank(Fundme.getowner());
        Fundme.withdraw();
        //assert
        uint256 endingownerbalance = Fundme.getowner().balance;
        uint256 endingFundmebalance = address(Fundme).balance;
        assertEq (endingFundmebalance,0);
        assertEq (startingfundmeBalance + startingownerbalance, endingownerbalance);
    }

    function testwithdrawfromMultiplefunders() public funded {
        uint160 numberofFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i=startingFunderIndex; i<numberofFunders; i++) {
            hoax(address(i), SEND_VALUE);
            Fundme.fund{value:SEND_VALUE}();            
        }
        uint256 startingownerbalance = Fundme.getowner().balance;
        uint256 startingfundmeBalance = address(Fundme).balance;        
        //Act
        vm.startPrank(Fundme.getowner());
        Fundme.withdraw();
        vm.stopPrank();
        //assert
        assert(address(Fundme).balance==0);
        assert(startingfundmeBalance + startingownerbalance == Fundme.getowner().balance);
    }

    function testwithdrawfromMultiplefunderscheaper() public funded {
        uint160 numberofFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i=startingFunderIndex; i<numberofFunders; i++) {
            hoax(address(i), SEND_VALUE);
            Fundme.fund{value:SEND_VALUE}();            
        }
        uint256 startingownerbalance = Fundme.getowner().balance;
        uint256 startingfundmeBalance = address(Fundme).balance;        
        //Act
        vm.startPrank(Fundme.getowner());
        Fundme.withdraw();
        vm.stopPrank();
        //assert
        assert(address(Fundme).balance==0);
        assert(startingfundmeBalance + startingownerbalance == Fundme.getowner().balance);
    }


    


}