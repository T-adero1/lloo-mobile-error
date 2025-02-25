import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_module.dart';
import '../onboarding_state.dart';

class AuthCompleteViewController extends LlooViewController<OnboardingState> {

  void onContinue() {
    Get.toNamed($appRoutes.onboarding.avatarRequest);
  }
}
