import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/services/leonardo_ai_service.dart';
import 'package:lloo_mobile/app/modules/user/services/user_restoration_service.dart';
import 'package:lloo_mobile/app/modules/user/services/user_api.dart';
import 'package:lloo_mobile/config.dart';
import 'services/avatar_generator_service.dart';
import 'user_state.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

//======================================================================
// MODULE INIT
//======================================================================

/// @throws
void userModuleInit() {
  L.info("USER", "Initializing User Module...");
  sharedBindings();
  registerRoutes();

  // Restore the user data
  final restore = Get.find<UserRestorationService>();
  restore.initializeUserDataStatus(); // must run before initial route
  // Let it run in the bg
  restore.restoreUserDataAsync().then((_) {});
}


//======================================================================
// SHARED DEPENDENCIES
//======================================================================
void sharedBindings() {
  // Building blocks

  // Shared amongst modules
  Get.put(UserState(), permanent: true); // keep state between routings
  Get.put(UserApi(), permanent: true);
  // Get.put<WalletApi>(WalletApi(), permanent: true);
  Get.put(LeonardoAIService(
    apiKey: kConfigLeonardoApiKey,
    modelId: kConfigLeonardoModelId,
    characterStrength: kConfigLeonardoCharacterStrength,
    prompt: kConfigLeonardoPrompt,
  ), permanent: true);
  Get.put(AvatarGeneratorBackgroundService(), permanent: true);
  Get.put(UserRestorationService(), permanent: true);
}

void registerRoutes() {
  // Routes moved to onboarding module
}