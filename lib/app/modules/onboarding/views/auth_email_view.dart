import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/centered_logo_view_base.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_state.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_styles.dart';
import 'package:magic_sdk/magic_sdk.dart';

import '../controllers/auth_email_view_controller.dart';

class AuthEmailView extends CenteredLogoViewBase<AuthEmailViewController, OnboardingState> {
  AuthEmailView({super.key}) : super(
    appBar: PushedViewNavBar(hideBottomLine: true),
    offsetUp: 77,

  );

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: OnboardingStyles.logoSpacing),

        Text(
            'Enter your email',
            style: theme.textTheme.titleLarge
        ),

        SizedBox(height: 2),

        Obx(() =>
            TextField(
              onSubmitted: (email) =>
                  controller.onEmailSubmitted(email),
              textInputAction: TextInputAction.done,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.black,
              ),
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'email@example.com',
                hintStyle: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.secondary.withAlpha(120),
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorText: state.emailError.value,
                errorStyle: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 14,
                ),
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
        ),
      ],
    );
  }
}
