// user_area_3_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/utils/formatting.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/modules/wallet/views/wallet_action_view_base.dart';

import '../widgets/wallet_entities_table.dart';


// holdings_view.dart
class HoldingsView extends WalletActionViewBase {
  HoldingsView({super.key}) : super(
    iconName: 'wallet',
    title: 'Holdings & Liquidity',
  );

  @override
  Widget buildContent(BuildContext context) {
    final userState = Get.find<UserState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
            onPressed: () => Get.toNamed('/user/transfer'),
            child: Text('Transfer Tokens')
        ),
        const SizedBox(height: 32),

        Obx(() {

          // NO TOKENS
          if (userState.stakedMemories.isEmpty) {
            return Text("You don't have any tokens.", style: theme.textTheme.bodySmall);
          } else {

            // TOKENS TABLE
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('Tokens you own:', style: theme.textTheme.bodySmall),

                const SizedBox(height: 12.0),

                Obx( () => WalletEntitiesTable(
                      entities: userState.stakedMemories.value,
                      rowBuilder: (context, memory, index) =>
                          WalletEntitiesTableRow(
                            thumbnailUrl: memory.imageUrl,
                            titleLabel: memory.title ?? 'Memory',
                            subtitleLabel: memory.description,
                            valueLine1: formattedAttnPrice(memory.calculatedPrice),
                            valueLine2: formattedAttnPrice(memory.targetPrice),
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

// ======================================================================
//
// class HoldingsRow extends StatelessWidget {
//   const HoldingsRow({
//     super.key,
//     required this.token,
//   });
//
//   final Token token;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.grey[800],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: CachedNetworkImage(imageUrl: token.thumbnailUrl)
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 token.name,
//                 style: Theme.of(context).textTheme.labelMedium,
//               ),
//               Text(
//                 token.description,
//                 style: Theme.of(context).textTheme.labelSmall,
//               ),
//             ],
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               token.attnValue.toStringAsFixed(0),
//               style: Theme.of(context).textTheme.labelMedium,
//             ),
//             Text(
//               '\$${token.fiatValue.toStringAsFixed(0)}',
//               style: Theme.of(context).textTheme.labelSmall,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }