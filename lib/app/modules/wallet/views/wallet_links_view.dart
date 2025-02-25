// user_area_5_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/core/utils/formatting.dart';
import 'package:lloo_mobile/app/core/widgets/app_icon.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/modules/user/user_styles.dart';

import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/modules/wallet/wallet_module.dart';
import '../wallet_styles.dart';
import '../widgets/wallet_entities_table.dart';
import 'wallet_action_view_base.dart';

class WalletLinksView extends WalletActionViewBase {
  WalletLinksView({super.key}) : super(
    iconName: 'links',
    title: 'Links & Liquidity',
  );

  @override
  Widget buildContent(BuildContext context) {
    final userState = Get.find<UserState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: kWalletStylesSectionSpacing),

        // LINK BUTTON
        FilledButton(
          onPressed: () => Get.toNamed($appRoutes.wallet.linkCreate),
          child: const Text('Link two Tokens'),
        ),

        const SizedBox(height: kWalletStylesSectionSpacing),

        // LINKS VIEW
        Obx(() {

          // NO TOKENS
          if (userState.linkedMemories.isEmpty) {
            return Text("You don't have any linked memory stakes.", style: theme.textTheme.bodySmall);
          } else {

            // TOKENS TABLE
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Memories you linked or added liquidity:', style: theme.textTheme.bodySmall),

                const SizedBox(height: 12.0),

                Obx( () => WalletEntitiesTable(
                    entities: userState.linkedMemories.value,
                    rowBuilder: (context, link, index) =>
                        WalletEntitiesTableRow(
                          iconName: '2link',
                          titleLabel: link.memory0TokenName,
                          secondaryLabel: link.memory1TokenName,
                          valueLine1: formattedAttnPrice(link.totalLockedValue),
                          valueLine2: '${formattedAttnPrice(link.memory0TokenReserve)} / ${formattedAttnPrice(link.memory1TokenReserve)}',
                        )),
                ),
              ],
            );
          }
        }),
      ],
    );
  }
}
