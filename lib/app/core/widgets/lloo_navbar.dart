import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/app_styles.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import 'package:lloo_mobile/app/modules/wallet/wallet_module.dart';
import '../../modules/user/widgets/user_info_mini.dart';
import 'lloo_logo.dart';

class LlooNavbar extends StatelessWidget implements PreferredSizeWidget {
  final userState = Get.find<UserState>();
  final bool hideLogo;

  LlooNavbar({super.key, this.hideLogo = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 175,
      shape: Border(
        bottom: BorderSide.none,
      ),

      // LOGO
      leading: hideLogo ? SizedBox() : InkWell( // gives a swish animation. width determined above
        onTap: () {
          // Add your logo tap action here
          Get.toNamed('/home');
        },
        child: Padding(
          padding: EdgeInsets.only(top: 16.0, left: kScreenPaddingSizeLR),
          child: Align(
              alignment: Alignment.centerLeft,
              child: LlooLogo(width: kLlooLogoWidth)
          ),
        ),
      ),

      // USER INFO
      actions: [
        Padding(
          padding: EdgeInsets.only(top: 16.0, right: kScreenPaddingSizeLR),
          child: GestureDetector(
            onTap: () {
              Get.toNamed($appRoutes.wallet.main);
            },
            child: UserInfoMini(),
          ),
        ),
      ],
    );
  }
}

