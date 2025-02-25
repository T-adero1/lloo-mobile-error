import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/modules/onboarding/controllers/avatar_camera_view_controller.dart';
import 'package:lloo_mobile/app/modules/onboarding/controllers/avatar_request_view_controller.dart';
import 'package:lloo_mobile/app/modules/onboarding/controllers/auth_complete_view_controller.dart';
import 'package:lloo_mobile/app/modules/onboarding/views/avatar_camera_view.dart';
import 'package:lloo_mobile/app/modules/onboarding/views/avatar_request_view.dart';
import 'package:lloo_mobile/app/modules/onboarding/views/avatar_generating_view.dart';
import 'package:lloo_mobile/app/modules/onboarding/views/auth_complete_view.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/core/services/leonardo_ai_service.dart';
import 'package:lloo_mobile/app/modules/onboarding/controllers/auth_email_view_controller.dart';
import 'package:lloo_mobile/app/modules/onboarding/views/auth_email_view.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_state.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/modules/user/services/wallet_api.dart';
import 'package:lloo_mobile/config.dart';
import 'package:lloo_mobile/app/modules/onboarding/services/logout_service.dart';
import 'package:magic_sdk/magic_sdk.dart';

import 'controllers/avatar_generating_view_controller.dart';

//=======================================================================
// INIT
//=======================================================================

void onboardingModuleInit() {
  L.info("ONBOARDING", "Initializing Onboarding Module...");

  Get.put(OnboardingState(), permanent: true);
  Get.put(LogoutService(), permanent: true);
  Get.put(WalletApi(), permanent: true);

  // Initialize Magic service with lazy loading and auto-recreation

  registerRoutes();
}

//======================================================================
// ROUTES
//======================================================================

extension OnboardingRoutes on AppRoutes {
  get onboarding => (
    auth: "/onboarding/auth",
    authComplete: "/onboarding/auth-complete",
    avatarRequest: "/onboarding/avatar-request",
    avatarCamera: "/onboarding/avatar-camera",
    avatarGenerating: "/onboarding/avatar-generating",
  );
}

void registerRoutes() {
  Get.lazyPut(() => TextEditingController());

  final routes = [
    GetPage(
      name: $appRoutes.onboarding.auth,
      page: () => AuthEmailView(),
      binding: BindingsBuilder(() {
        Get.put(TextEditingController());
        Get.put(AuthEmailViewController());
      }),
    ),
    GetPage(
      name: $appRoutes.onboarding.authComplete,
      page: () => AuthCompleteView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthCompleteViewController());
      }),
    ),
    GetPage(
      name: $appRoutes.onboarding.avatarRequest,
      page: () => AvatarRequestView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AvatarRequestViewController());
      }),
    ),
    GetPage(
      name: $appRoutes.onboarding.avatarCamera,
      page: () => AvatarCameraView(),
      binding: BindingsBuilder(() {
           // @TODO: #med-p Figure out why Get.dialog is deleting these
        Get.put(AvatarCameraViewController(), permanent: true);
      }),
    ),
    GetPage(
      name: $appRoutes.onboarding.avatarGenerating,
      page: () => AvatarGeneratingView(),
      binding: BindingsBuilder(() {
        Get.put(AvatarGeneratingViewController(), permanent: true);
      }),
    ),
  ];

  // @TODO: #low-p This is a better paradigm. Change all to align
  //Get.addPages(routes);
  $appRoutes.registerRoutes(routes);
}