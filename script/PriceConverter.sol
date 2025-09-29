//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
//import AggregatorV3Interface from "./AggregatorV3Interface.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
library PriceConverter {
    function getprice(AggregatorV3Interface pricefeed) internal view returns(uint256){
	    (,int256 price,,,) = pricefeed.latestRoundData();
	    return uint256 (price * 1e10);
    }

    function getConversionRate (uint256 ethAmount, AggregatorV3Interface pricefeed) internal view returns (uint256) {
	    uint256 ethprice = getprice(pricefeed);
	    uint256 ethAmountInUSD = (ethprice * ethAmount)/1e18;
	    return ethAmountInUSD;
    }
}