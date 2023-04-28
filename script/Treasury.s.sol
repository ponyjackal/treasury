// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { UUPSProxy } from "../src/proxies/UUPSProxy.sol";
import { Treasury } from "../src/Treasury.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployTreasury is Script {
    UUPSProxy proxy;
    Treasury internal wrappedProxyV1;

    function run() public {
        vm.startBroadcast();

        Treasury implementationV1 = new Treasury();

        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(implementationV1), "");

        // wrap in ABI to support easier calls
        wrappedProxyV1 = Treasury(address(proxy));

        vm.stopBroadcast();
    }
}

contract UpgradeTreasury is Script {
    address proxy = address(0);
    Treasury internal wrappedProxyV1;

    function run() public {
        vm.startBroadcast();

        // wrap in ABI to support easier calls
        wrappedProxyV1 = Treasury(address(proxy));

        // new implementation
        Treasury implementationV2 = new Treasury();
        wrappedProxyV1.upgradeTo(address(implementationV2));

        vm.stopBroadcast();
    }
}
