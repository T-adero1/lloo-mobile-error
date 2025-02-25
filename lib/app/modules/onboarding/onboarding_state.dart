import 'package:get/get.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

class OnboardingState {
  var emailError = Rx<String?>(null);
  var otpError = Rx<String?>(null);
  var showingOtp = false.obs;
  var cameraIsInitialized = false.obs;
  var cameraProcessingMessage = Rx<String?>(null);
  var userWasNew = false.obs;

  OnboardingState();
}