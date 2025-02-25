import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/core/lloo_exceptions.dart';
import 'package:lloo_mobile/app/debug/debug.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_module.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_state.dart';
import 'package:lloo_mobile/app/modules/user/models/user_details.dart';
import 'package:lloo_mobile/app/modules/user/services/user_api.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/utils/form_validator.dart';
import 'package:lloo_mobile/app/modules/user/services/user_restoration_service.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';

import '../../user/services/wallet_api.dart';

class AuthEmailViewController extends LlooViewController<OnboardingState> {
  final emailController = Get.find<TextEditingController>();
  final _userState = Get.find<UserState>();
  final _userApi = Get.find<UserApi>();
  final _userRestorationService = Get.find<UserRestorationService>();
  final _walletApi = Get.find<WalletApi>();

  @override
  void onReady() {
    super.onReady();

    // Debug autofill
    emailController.text = kDebugOnboardingEmailAutofill ?? '';
  }

  void onEmailSubmitted(String? email) async {
    L.info("AUTH_EMAIL_VIEW_CONTROLLER", "Email submitted: $email");

    //=======================================================================
    // VALIDATE
    //=======================================================================

    final error = _validateEmail(email);
    state.emailError.value = error;
    if (error != null) {
      L.debug("AUTH_EMAIL_VIEW_CONTROLLER", "Email validation failed: $error");
      return;
    }

    //=======================================================================
    try {
      //=======================================================================
      // REGISTER/RESTORE LLOO USER
      // - If the user already exists, restore them and reload their data
      //=======================================================================
      L.info('AUTH_EMAIL_VIEW_CONTROLLER', 'Registering user $email');

      // Check whether a user already exists
      UserDetails? user = await _userApi.fetchDetailsForUserEmail(email!);

      if (user != null) {
        user = await _userApi.fetchDetailsForUserEmail(email);
        state.userWasNew.value = false;
        L.info("AUTH_EMAIL_VIEW_CONTROLLER", "...found pre-existing user...");
      } else {
        user = await _userApi.registerUser(email: email);
        state.userWasNew.value = true;
        L.info("AUTH_EMAIL_VIEW_CONTROLLER", "...Created new user: $email");
      }
      // Save the state
      _userState.userDetails.value = user;

      // Create a wallet, add to the user details
      L.info("AUTH_EMAIL_VIEW_CONTROLLER", "Fetching wallet address...");
      final walletAddress = await _walletApi.fetchWalletAddress(email!);
      _userState.userDetails.value =
          _userState.userDetails.value!.copyWith(walletAddress: walletAddress);

      await _userApi.updateUserDetails(_userState.userDetails.value!);

      // Do the user data restoration here as to not have collisions with the wallet
      L.info("AUTH_EMAIL_VIEW_CONTROLLER", "Starting user data restoration bg service...");
      _userRestorationService.restoreUserDataAsync().then((_){});


      // Navigate to avatar screen
      Get.toNamed($appRoutes.onboarding.authComplete);

    } on LlooException catch (e) {

      L.error("AUTH_EMAIL_VIEW_CONTROLLER", "Error registering user $e.toString()");
      // @TODO: Show popup

    }
  }

  String? _validateEmail(String? email) {
    final error = FormValidator.validateEmail(email);
    return error;
  }

}
