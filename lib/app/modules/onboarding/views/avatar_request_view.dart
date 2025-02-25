import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import 'package:lloo_mobile/app/core/centered_logo_view_base.dart';
import 'package:lloo_mobile/app/core/vertically_centered_lloo_view_base.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/widgets/lloo_logo.dart';
import '../controllers/avatar_request_view_controller.dart';
import '../onboarding_state.dart';
import '../widgets/dotted_circle.dart';

class AvatarRequestView extends VerticallyCenteredLlooViewBase<AvatarRequestViewController, OnboardingState> {
  AvatarRequestView({super.key}) : super(
    appBar: PushedViewNavBar(hideBottomLine: true),
    // offsetUp: 100,
  );

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        GestureDetector(
          onTap: () => controller.onAvatarSelected(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth;
              return DottedCircle(
                width: size,
                height: size,
                color: theme.colorScheme.surfaceDim,
                strokeWidth: 1.0,
                showPlus: true,
                plusColor: theme.colorScheme.primary,
                plusStrokeWidth: 1.0
              );
            },
          ),
        ),
        SizedBox(height: 32),

        LlooLogo(width: kLlooLogoWidth),

        SizedBox(height: 20),

        Text(
          'Please add an avatar\nto your wallet',
          style: theme.textTheme.titleLarge
        ),
      ],
    );
  }
}
