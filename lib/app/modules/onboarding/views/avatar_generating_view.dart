import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import 'package:lloo_mobile/app/core/vertically_centered_lloo_view_base.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/widgets/lloo_logo.dart';
import 'package:lloo_mobile/app/modules/lloo_read/lloo_read_module.dart';
import '../controllers/avatar_generating_view_controller.dart';
import '../onboarding_state.dart';

class AvatarGeneratingView extends VerticallyCenteredLlooViewBase<AvatarGeneratingViewController, OnboardingState> {
  AvatarGeneratingView({super.key}) : super(
    appBar: null,
  );

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Circle with blue border for avatar
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxWidth, 
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Obx(() => Image.network(
                  controller.avatarUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                    Container(color: theme.colorScheme.surfaceVariant),
                )),
              ),
            );
          },
        ),
        
        const SizedBox(height: 32),

        LlooLogo(width: kLlooLogoWidth),

        const SizedBox(height: 8),

        Text('Generating your avatar', style: theme.textTheme.titleLarge,),

        const SizedBox(height: 32),

        // OK button at the bottom
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => controller.handleButtonPressed(),
            child: Text('OK'),
          ),
        ),
      ],
    );
  }
}
