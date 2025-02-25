import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/app_styles.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_module.dart';
import 'package:lloo_mobile/app/modules/user/user_styles.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';

class UserInfoMini extends StatelessWidget {

  final bool isOnInverseSurface;

  const UserInfoMini({
    super.key,
    this.isOnInverseSurface = false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userState = Get.find<UserState>();

    return Obx(() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Check for user details and show nav to create if none
          if (userState.userDetails.value == null)
            TextButton(
                onPressed: () => Get.toNamed($appRoutes.onboarding.auth),
                child: Text('Connect', style: theme.textTheme.labelMedium),
            )
          else ...[
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(userState.userDetails.value!.avatarUrl ?? ''),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userState.userDetails.value!.userId,
                  style: theme.textTheme.labelSmall!.copyWith(
                      color: isOnInverseSurface
                          ? theme.colorScheme.onInverseSurface
                          : theme.colorScheme.primary
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '156 ATTN',
                  style: theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.tertiary),
                ),
              ],
            ),
          ] // end if/else
        ],
      ),
    );
  }
}
