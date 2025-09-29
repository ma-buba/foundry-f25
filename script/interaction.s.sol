// //fund
// //withdraw
// //SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src//DevopsTools.sol";

contract Fundfundme is Script {

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment{
            "fundme",
            block.chainid
        };
    }
}