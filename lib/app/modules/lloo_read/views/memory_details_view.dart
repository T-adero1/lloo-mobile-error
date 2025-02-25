import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/modules/lloo_read/widgets/price_info_mini.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/modules/user/widgets/user_info_mini.dart';
import 'package:lloo_mobile/app/app_theme.dart';

import '../controllers/memory_details_view_controller.dart';
import '../lloo_read_state.dart';
import '../widgets/memory_details/comments_tab.dart';
import '../widgets/memory_details/info_tab.dart';
import '../widgets/memory_details/memory_detail_header_image.dart';
import '../widgets/memory_details/stakers_tab.dart';
import '../widgets/memory_info_mini.dart';
import '../widgets/vertical_vignette.dart';


class MemoryDetailsView extends LlooView<MemoryDetailsViewController, LlooReadState> {
  MemoryDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the view model for this memory
    final model = controller.model;
    final userState = Get.find<UserState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [

                Obx(() => MemoryDetailsHeaderImage(memory: model.memory.value)),

                // GRADIENT
                VerticalVignette(height: 120),
                Positioned(bottom: 0, left: 0, right: 0, child: VerticalVignette(height: 160, isBottomUp: true)),

                // BACK BTN
                Positioned(top: 44, left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: kLightThemeColors.inverseText), // always light theme
                      onPressed: () {
                        Get.back();
                      },
                    )
                ),

                // Positioned(top: 44, left: 16, child: PushedViewNavBar()),

                // USER INFO
                // (sep Obx as its updates differently
                Positioned(bottom: 16, left: 16, child: UserInfoMini(isOnInverseSurface: true)),

                // MEMORY INFO
                Obx(() => Positioned(bottom: 16, right: 16, child: PriceInfoMini(memory: model.memory.value, isOnInverseSurface: true))),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: kScreenPaddingSizeLR, vertical: 22),
              child: MemoryDetailsStakePanel(),
            ),

            // @TODO: Needs this to be a stateful wigget. maybe another way?
            // TabBar(
            //   tabs: [
            //     Tab(text: 'Info'),
            //     Tab(text: 'Stakers'),
            //     Tab(text: 'Comments'),
            //   ],
            // ),
            //
            // Expanded(
            //   child: TabBarView(
            //     controller: TabController(length: 3, vsync: this),
            //     children: [
            //       // These are subviews in a sense and handle their own state
            //       InfoTab(controller: controller, viewModel: model),
            //       StakersTab(),
            //       CommentsTab(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------


class MemoryDetailsStakePanel extends StatelessWidget {
  const MemoryDetailsStakePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.find<LlooReadState>();
    final theme = Theme.of(context);

    final hasStaking = false;

    if (!hasStaking) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No one staked yet, be the first:",
              style: theme.textTheme.bodyMedium,
            ),

            SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: (){},
                  child: const Text('Stake your ATTN')),
            )

          ]);
    } else {
      return Image.network('https://example.com/graph.jpg', height: 200);
    }
  }
}


