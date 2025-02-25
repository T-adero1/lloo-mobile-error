// user_wallet_action_view_base.dart
import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/widgets/app_icon.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import '../controllers/wallet_view_controller.dart';
import '../wallet_state.dart';
import '../wallet_styles.dart';


abstract class WalletActionViewBase extends LlooView<WalletViewController, WalletState>{
  final String iconName;
  final String title;

  WalletActionViewBase({
    super.key,
    required this.iconName,
    required this.title,
  });

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PushedViewNavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kScreenPaddingSizeLR),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: kWalletStylesSectionSpacing),

              Align(
                alignment: Alignment.centerLeft,
                child: AppIcon(iconName, size: 24),
              ),

              const SizedBox(height: 5),

              Text(title, style: theme.textTheme.titleLarge),

              const SizedBox(height: kWalletStylesSectionSpacing),

              buildContent(context),
            ],
          ),
        ),
      ),
    );
  }
}
