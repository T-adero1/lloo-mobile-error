// memories_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/widgets/large_memories_list.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/modules/wallet/wallet_state.dart';

import '../controllers/wallet_view_controller.dart';
import '../widgets/wallet_staking_list.dart';

class WalletMemoriesView extends LlooView<WalletViewController, WalletState> {
  WalletMemoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final userAreaState = Get.find<UserState>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nypole'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Memories'),
              Tab(text: 'User\'s Staking'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Memories tab
            Obx(
              () => userAreaState.createdMemories.isEmpty
                  ? const Center(child: Text('No Memories'))
                  : LargeMemoriesList(memories: userAreaState.createdMemories),
            ),
            // User's Staking tab
            Obx(
              () => WalletStakingsList(stakings: userAreaState.userStakings),
            ),
          ],
        ),
      ),
    );
  }
}