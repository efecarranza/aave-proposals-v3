// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';

import 'forge-std/Test.sol';
import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV2TestBase.sol';
import {AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916} from './AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916.sol';

/**
 * @dev Test for AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916
 * command: FOUNDRY_PROFILE=avalanche forge test --match-path=src/20240916_Multi_ReserveFactorUpdatesLateSeptember/AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916.t.sol -vv
 */
contract AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916_Test is ProtocolV2TestBase {
  AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916 internal proposal;

  struct Changes {
    address asset;
    uint256 reserveFactor;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 50609721);
    proposal = new AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    (ReserveConfig[] memory allConfigsBefore, ReserveConfig[] memory allConfigsAfter) = defaultTest(
      'AaveV2Avalanche_ReserveFactorUpdatesLateSeptember_20240916',
      AaveV2Avalanche.POOL,
      address(proposal)
    );

    address[] memory assetsChanged = new address[](6);
    assetsChanged[0] = AaveV2AvalancheAssets.DAIe_UNDERLYING;
    assetsChanged[1] = AaveV2AvalancheAssets.USDCe_UNDERLYING;
    assetsChanged[2] = AaveV2AvalancheAssets.USDTe_UNDERLYING;
    assetsChanged[3] = AaveV2AvalancheAssets.WAVAX_UNDERLYING;
    assetsChanged[4] = AaveV2AvalancheAssets.WBTCe_UNDERLYING;
    assetsChanged[5] = AaveV2AvalancheAssets.WETHe_UNDERLYING;

    Changes[] memory assetChanges = new Changes[](6);
    assetChanges[0] = Changes({
      asset: AaveV2AvalancheAssets.DAIe_UNDERLYING,
      reserveFactor: proposal.DAIe_RF()
    });
    assetChanges[1] = Changes({
      asset: AaveV2AvalancheAssets.USDCe_UNDERLYING,
      reserveFactor: proposal.USDCe_RF()
    });
    assetChanges[2] = Changes({
      asset: AaveV2AvalancheAssets.USDTe_UNDERLYING,
      reserveFactor: proposal.USDTe_RF()
    });
    assetChanges[3] = Changes({
      asset: AaveV2AvalancheAssets.WAVAX_UNDERLYING,
      reserveFactor: proposal.WAVAX_RF()
    });
    assetChanges[4] = Changes({
      asset: AaveV2AvalancheAssets.WBTCe_UNDERLYING,
      reserveFactor: proposal.WBTCe_RF()
    });
    assetChanges[5] = Changes({
      asset: AaveV2AvalancheAssets.WETHe_UNDERLYING,
      reserveFactor: proposal.WETHe_RF()
    });

    _noReservesConfigsChangesApartFrom(allConfigsBefore, allConfigsAfter, assetsChanged);

    for (uint i = 0; i < assetChanges.length; i++) {
      ReserveConfig memory cfg = _findReserveConfig(allConfigsAfter, assetChanges[i].asset);
      assertEq(cfg.reserveFactor, assetChanges[i].reserveFactor);
    }
  }
}
