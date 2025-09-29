//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";


contract Helperconfig is Script{
    struct Networkconfig{
        address pricefeed;
    }


    Networkconfig public activeNetworkconfig;

    constructor(){
        if (block.chainid==11155111) {
            activeNetworkconfig = getSepoliaEthconfig();
        } else {
            activeNetworkconfig = getorcreateAnvilconfig();
        }
    }
    


    function getSepoliaEthconfig() public pure returns(Networkconfig memory) {
        Networkconfig memory sepoliaconfig = Networkconfig({pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaconfig;
    }


    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;

    

    function getorcreateAnvilconfig() public returns (Networkconfig memory) {
        //1. deploy mock
        //2. return mock address
        if (activeNetworkconfig.pricefeed != address(0)) {
            return activeNetworkconfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();
        Networkconfig memory anvilconfig = Networkconfig({pricefeed: address(mockpricefeed)});
        return anvilconfig;    
    }
}