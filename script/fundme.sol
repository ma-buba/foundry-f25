//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "script/PriceConverter.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// // import AggregatorV3Interface from "./AggregatorV3Interface.sol";
// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// library PriceConverter {
//     function getprice() internal view returns(uint256){
// 	    AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
// 	    (,int256 price,,,) = pricefeed.latestRoundData();
// 	    return uint256 (price * 1e10);
//     }

//     function getConversionRate (uint256 ethAmount) internal view returns (uint256) {
// 	    uint256 ethprice = getprice();
// 	    uint256 ethAmountInUSD = (ethprice * ethAmount)/1e18;
// 	    return ethAmountInUSD;
//     }

//     function getversion() public view returns(uint256){
// 	    return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
//     }
// }
// import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";

contract fundme {
    using PriceConverter for uint256;
	uint256 public constant MINIMUM_USD = 5e18;
    address[] private s_funders;
    mapping (address funder => uint256 amountfunded) private s_Addresstoamountfunded;

	address private immutable i_owner;
	AggregatorV3Interface private s_priceFeed;

	  constructor(address pricefeed) {
		  i_owner = msg.sender;
		  s_priceFeed = AggregatorV3Interface(pricefeed);
	  }

    function fund() public payable {
      require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "didn't send enough ETH");
      //to help keeps records of who sends money
      s_funders.push (msg.sender);
      s_Addresstoamountfunded [msg.sender] = s_Addresstoamountfunded [msg.sender] + msg.value;
    }

    //to be able to withdraw money 
    //FOR LOOP
    //to withdraw 
    //for(/*startingindex, endingindex, stepAmount*/)

	function getVersion() public view returns (uint256) {
		return s_priceFeed.version();
    }

	function cheaperwithdraw() public onlyowner {
		uint256 fundersLength = s_funders.length;
		for(uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++)
		{
			address funder = s_funders[funderIndex];
			s_Addresstoamountfunded[funder] = 0;
		}
		
		//to reset an array
		s_funders = new address[](0);

		//to withdraw funds using call
		(bool callSuccess,) = payable(msg.sender).call{value: address(this).balance} ("");
		require(callSuccess, "call failed");

	}

	function withdraw() public onlyowner {
		for(uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++)
		{
			address funder = s_funders[funderIndex];
			s_Addresstoamountfunded[funder] = 0;
		}

		//to reset an array
		s_funders = new address[](0);

		//to withdraw funds using call
		(bool callSuccess,) = payable(msg.sender).call{value: address(this).balance} ("");
		require(callSuccess, "call failed");
	}


	  //edit withdraw function
	  //require (msg.sender == owner, "must be the owner:");

	  //function modifiers
	error fundme_Notowner ();
	  
	modifier onlyowner() {
		if (msg.sender != i_owner) {revert fundme_Notowner();}
		_;
	}

	receive() external payable {
		fund();
	}


	fallback() external payable {
		fund();
	}

		function getAddresstoAmountfunded (address fundingAddress) external view returns (uint256) {
		return s_Addresstoamountfunded[fundingAddress];
	}

	function getfunder (uint256 Index) external view returns (address) {
		return s_funders[Index];
	}

	function getowner() external view returns(address){
		return i_owner;
	}
}
// notice gas efficiency
//901679
//878208 after adding constant 
//851617 after adding immutable 
//823698 after replacing require with custom error 

