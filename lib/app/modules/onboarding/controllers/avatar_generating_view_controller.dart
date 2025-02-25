import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/modules/lloo_read/lloo_read_module.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import '../onboarding_state.dart';

class AvatarGeneratingViewController extends LlooViewController<OnboardingState> {
  final UserState _userState = Get.find();
  
  String? get avatarUrl => _userState.userDetails.value?.avatarUrl;

  void handleButtonPressed() {
    Get.until((route) => route.settings.name == $appRoutes.llooRead.home);
  }
}
