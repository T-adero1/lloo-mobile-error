import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/app_theme.dart';

import '../../../app_styles.dart';

class WalletStakingsList extends StatelessWidget {
  const WalletStakingsList({
    super.key,
    required this.stakings,
  });

  final List<Map<String, dynamic>> stakings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: kScreenPaddingSizeLR,
        vertical: 16.0,
      ),
      itemCount: stakings.length,
      itemBuilder: (context, index) {
        final staking = stakings[index];
        return WalletStakingTile(staking: staking);
      },
    );
  }
}

class WalletStakingTile extends StatelessWidget {
  const WalletStakingTile({
    super.key,
    required this.staking,
  });

  final Map<String, dynamic> staking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        staking['title'],
        style: Theme.of(context).defaultFont(   // @TODO: Align these to the theme
          size: 16.0,
          weight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${staking['token']} ${staking['amount']} ATTN',
        style: Theme.of(context).defaultFont(  // @TODO: Align these to the theme
          size: 14.0,
          color: AppStyles.colors.secondaryText,
        ),
      ),
    );
  }
}