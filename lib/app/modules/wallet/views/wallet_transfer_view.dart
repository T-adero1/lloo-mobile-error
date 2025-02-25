// user_area_4_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';

import 'wallet_action_view_base.dart';

class WalletTransferView extends WalletActionViewBase {
  WalletTransferView({super.key}) : super(
    iconName: 'wallet',
    title: 'Transfer Tokens',
  );

  @override
  Widget buildContent(BuildContext context) {
    const kInputFieldSpacing = 10.0;  // vertical between them
    final userState = Get.find<UserState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        // RECIPIENT
        const TextField(
          decoration: InputDecoration(
            labelText: 'Recipient Wallet ID (or nickname)',
          ),
        ),

        const SizedBox(height: kInputFieldSpacing),


        // TOKEN
        Obx(() => DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Which Token to Transfer',
            ),
            items: userState.stakedMemories.map((memory) =>
                DropdownMenuItem(value: memory.id,
                    child: Text(memory.title ?? memory.description ?? 'memory'))
            ).toList(),
            onChanged: (value) {
              // TODO: Handle token selection
            },
          ),
        ),


        const SizedBox(height: kInputFieldSpacing),


        // TOKEN AMOUNT
        const TextField(
          decoration: InputDecoration(
            labelText: 'How many tokens?',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 32),


        // BUTTON
        FilledButton(
          onPressed: () {
            // TODO: Implement token transfer
          },
          child: const Text('Transfer'),
        ),
      ],
    );
  }
}