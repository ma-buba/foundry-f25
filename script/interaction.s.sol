// //fund
// //withdraw
// //SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {fundme} from "../src/fundme.sol";

contract Fundfundme is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundfundme (address mostRecentlyDeployed) public{
        fundme(payable (mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        console.log("funded fundme with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "fundme",
            block.chainid
        );
        vm.startBroadcast();
        fundfundme (mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundme is Script{
	function Withdrawfundme(address mostRecentlyDeployed) public{
        vm.startBroadcast();
		fundme(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
	}

}