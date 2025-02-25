
import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/app_styles.dart';
import 'package:get/get.dart';

import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

class PushedViewNavBar extends AppBar {
  PushedViewNavBar({
    super.key,
    bool hideBottomLine = false,
  }) : super(
    bottom: hideBottomLine ? null : PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: AppStyles.colors.divider,
        height: 1.0,
      ),
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: AppStyles.colors.primaryText),
      onPressed: () {
        Get.back();
      },
    ),
  );

  // PushedViewNavBar({super.key}) : super(
  //   leading: IconButton(
  //     icon: Icon(Icons.arrow_back, color: AppStyles.colors.primaryText),
  //     onPressed: () {
  //       Get.back();
  //     },
  //   ));
}