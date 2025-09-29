//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {fundme} from "./fundme.sol";
import {Helperconfig} from "./Helperconfig.s.sol";

contract Deployfundme is Script {
    function run() external returns (fundme) {
        //before starting the broadcast, meaning not a real transaction
        Helperconfig helperconfig = new Helperconfig();
        address EthUsdPricefeed = helperconfig.activeNetworkconfig();
        vm.startBroadcast();
        fundme Fundme=new fundme(EthUsdPricefeed);
        vm.stopBroadcast();
        return Fundme;
    }
}