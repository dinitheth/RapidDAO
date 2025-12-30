// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./RapidDAO.sol";

contract TemporaryDeployFactory {
    /// @notice Emitted when all contracts are deployed
    /// @dev This event enables frontend to query deployed contracts by tx hash
    event ContractsDeployed(
        address indexed deployer,
        string[] contractNames,
        address[] contractAddresses
    );

    constructor() {
        // Deploy RapidDAO contract
        RapidDAO rapidDAO = new RapidDAO();

        // Build dynamic arrays for event
        string[] memory contractNames = new string[](1);
        contractNames[0] = "RapidDAO";

        address[] memory contractAddresses = new address[](1);
        contractAddresses[0] = address(rapidDAO);

        // Emit event with all contract info
        emit ContractsDeployed(msg.sender, contractNames, contractAddresses);
        selfdestruct(payable(msg.sender));
    }
}
