// wallet_main_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/widgets/app_icon.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/modules/user/widgets/user_info_mini.dart';

import '../controllers/wallet_view_controller.dart';
import '../services/wallet_service.dart';
import '../wallet_state.dart';
import '../wallet_styles.dart';

class WalletMainView extends LlooView<WalletViewController, WalletState> {
  WalletMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = Get.find<UserState>();

    return Scaffold(
      appBar: PushedViewNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Obx( () => CircleAvatar(
                          radius: 60,
                          backgroundImage: CachedNetworkImageProvider(userState.userDetails.value?.avatarUrl ?? ''),
                        )),
                        SizedBox(height: 16),
                        Text(
                          userState.userDetails.value!.username ?? '---',  // @TODO: Handle this...default to email preamble
                          style: theme.textTheme.titleLarge
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total Holdings',
                          style: WalletStyles.holdingsLabelFont,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '2,000 ATTN',
                          style: WalletStyles.holdingsValueFont,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                },
                                child: const Text('Buy ATTNs'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  Get.toNamed('/wallet/transfer');
                                },
                                child: const Text('Transfer'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const AppIcon('wallet'),
                    title: const Text('Holdings'),
                    onTap: () => Get.toNamed('/wallet/holdings'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const AppIcon('links'),
                    title: const Text('Links'),
                    onTap: () => Get.toNamed('/wallet/links'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const AppIcon('user'),
                    title: const Text('Memories'),
                    onTap: () => Get.toNamed('/wallet/memories'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const AppIcon('transfer'),
                    title: const Text('Transactions'),
                    onTap: () => Get.toNamed('/wallet/transactions'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const AppIcon('exit'),
                    title: const Text('Logout'),
                    onTap: () => controller.onLogoutTapped(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
