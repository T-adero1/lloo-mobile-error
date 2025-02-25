import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import 'package:lloo_mobile/app/core/vertically_centered_lloo_view_base.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/widgets/lloo_logo.dart';
import '../controllers/auth_complete_view_controller.dart';
import '../onboarding_state.dart';

class AuthCompleteView extends VerticallyCenteredLlooViewBase<AuthCompleteViewController, OnboardingState> {
  AuthCompleteView({super.key}) : super(
    appBar: PushedViewNavBar(hideBottomLine: true),
  );

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LlooLogo(width: kLlooLogoWidth),
        
        SizedBox(height: 20),

        Obx(() => Text(
          state.userWasNew.value 
            ? "We've opened you a wallet"
            : 'Welcome Back',
          style: theme.textTheme.titleLarge
        )),

        SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => controller.onContinue(),
            child: Text('Continue'),
          ),
        ),
      ],
    );
  }
}
