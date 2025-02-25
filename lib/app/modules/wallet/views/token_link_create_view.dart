// link_create_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'wallet_action_view_base.dart';
import '../../user/user_state.dart';
import '../wallet_styles.dart';

class TokenLinkCreateView extends WalletActionViewBase {
  TokenLinkCreateView({super.key}) : super(
    iconName: 'links',
    title: 'Create a Link',
  );

  @override
  Widget buildContent(BuildContext context) {
    final userState = Get.find<UserState>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        const SizedBox(height: kWalletStylesSectionSpacing),

        // TOKEN A
        Obx(() => DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Token A',
          ),
          items: userState.stakedMemories
              .where((memory) => memory.id != state.createLinkSelectedMemoryBId.value) // filter selected
              .map((memory) => DropdownMenuItem(value: memory.id, child: Text(memory.title ?? memory.id)))
              .toList(),
          onChanged: (value) {
            state.createLinkSelectedMemoryAId.value = value;
          },
        )),

        const SizedBox(height: kWalletStylesInputSpacing),

        // TOKEN B
        Obx(() => DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Token B',
          ),
          items: userState.stakedMemories
              .where((memory) => memory.id != state.createLinkSelectedMemoryAId.value) // filter selected
              .map((memory) => DropdownMenuItem(value: memory.id, child: Text(memory.title ?? memory.id)))
              .toList(),
          onChanged: (value) {
            state.createLinkSelectedMemoryBId.value = value;
          },
        )),

        const SizedBox(height: kWalletStylesInputSpacing),

        // VALUE TO LOCK IN
        TextField(
          decoration: const InputDecoration(
            hintText: 'Locked Value (e.g. \$50)',
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        ),

        const SizedBox(height: kWalletStylesSectionSpacing),

        FilledButton(
          onPressed: () {
            // TODO: Implement create link functionality
          },
          child: const Text('Create a Link'),
        ),
      ],
    );
  }
}