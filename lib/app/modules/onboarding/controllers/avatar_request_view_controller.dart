import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import '../onboarding_state.dart';
import '../onboarding_module.dart';

class AvatarRequestViewController extends LlooViewController<OnboardingState> {
  final UserState _userState = Get.find();
  
  void onAvatarSelected() async {
    Get.toNamed($appRoutes.onboarding.avatarCamera);
  }
}
