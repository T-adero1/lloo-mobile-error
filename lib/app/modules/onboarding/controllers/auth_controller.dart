// import 'dart:async';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:lloo_mobile/app/app_routes.dart';
// import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
// import 'package:lloo_mobile/app/core/lloo_exceptions.dart';
// import 'package:lloo_mobile/app/core/utils/form_validator.dart';
// import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
// import 'package:lloo_mobile/app/debug/debug.dart';
// import 'package:lloo_mobile/app/modules/onboarding/services/magic_service.dart';
// import 'package:lloo_mobile/app/modules/user/models/user_details.dart';
// import 'package:lloo_mobile/app/modules/user/services/user_api.dart';
// import 'package:lloo_mobile/app/modules/user/user_state.dart';
// import '../onboarding_state.dart';
// import '../onboarding_module.dart';
//
// /// (Non-view) Controller that persists through the auth VCs for handling auth and wallet creation
// class AuthController extends GetxController {
//
//   // final _magicService = Get.find<MagicService>();
//   final _userApi = Get.find<UserApi>();
//   final _userState = Get.find<UserState>();
//   StreamSubscription? _walletAuthSubscription;
//
//   //
//   // /// Initialize magic service with proper context
//   // Future<void> initializeMagicService(BuildContext context) async {
//   //   try {
//   //     await _magicService.init(context: context);
//   //     L.debug("AUTH_VIEW_CONTROLLER", "Magic service initialized");
//   //   } catch (e) {
//   //     L.error("AUTH_VIEW_CONTROLLER", "Failed to initialize Magic service: $e");
//   //   }
//   // }
//
//   @override
//   void onClose() {
//     _walletAuthSubscription?.cancel();
//     emailController.dispose();
//     super.onClose();
//   }
//
//   // ---------------------------------------------------------------------
//
//   String? validateEmail(String? email) {
//     final error = FormValidator.validateEmail(email);
//     state.emailError.value = error ?? '';
//     return error;
//   }
//
//
//   /// Validate, handle account creation/restore, do wallet creation/auth
//   void onEmailSubmitted(String? email) async {
//     L.info("AUTH_VIEW_CONTROLLER", "Email submitted: $email");
//
//     final error = validateEmail(email);
//     if (error != null) {
//       L.error("AUTH_VIEW_CONTROLLER", "Email validation failed: $error");
//       // @TODO: #hi-p — Handle UI error handling
//       return;
//     }
//
//     try {
//
//       //=======================================================================
//       // REGISTER LLOO USER
//       //=======================================================================
//
//       // Check whether a user already exists
//       UserDetails? user = await _userApi.fetchDetailsForUserEmail(email!);
//
//       if (user != null) {
//         L.warn("AUTH_VIEW_CONTROLLER",
//             "User already exists in db with email: $email. Should only be onboarding error'ed out during submission");
//         user = await _userApi.fetchDetailsForUserEmail(email);
//       } else {
//         L.info("AUTH_VIEW_CONTROLLER", "Registering new user in db with email: $email");
//         user = await _userApi.registerUser(email: email);
//       }
//       // Save the state
//       _userState.userDetails.value = user;
//
//       //=======================================================================
//       // WALLET CREATION/AUTH
//       //=======================================================================
//       L.info("AUTH_VIEW_CONTROLLER", "Creating/authing wallet for email: $email");
//
//       // Setup auth event listener
//       _walletAuthSubscription?.cancel();
//       _walletAuthSubscription = _magicService.authEvents.listen(_handleWalletAuthEvent);
//
//       // Start the login process
//       await _magicService.startEmailLogin(email);  // await for just the auth init (not the full auth completion)
//       state.showingOtp.value = true;
//
//     } on LlooException catch (e) {
//       L.error("AUTH_VIEW_CONTROLLER", "Failed to submit email: ${e.message}");
//       state.emailError.value = e.message;
//     } on Exception catch (e) {
//       L.error("AUTH_VIEW_CONTROLLER", "Failed to submit email: $e");
//     }
//   }
//
//   void onOtpSubmitted(String otp) async {
//     L.info("AUTH_VIEW_CONTROLLER", "OTP submitted");
//     state.otpError.value = '';
//
//     await _magicService.verifyOtp(otp);
//   }
//
//   void _handleWalletAuthEvent(MagicAuthResult result) async {
//     L.debug("AUTH_VIEW_CONTROLLER", "Received auth event: $result");
//
//     switch (result.state) {
//       case MagicAuthState.otpSent:
//         // Already handled by showing OTP form
//         break;
//
//       case MagicAuthState.invalidOtp:
//         state.otpError.value = 'Invalid code, please try again';
//         break;
//
//       case MagicAuthState.success:
//         if (result.didToken == null) {
//           L.error("AUTH_VIEW_CONTROLLER", "Got success but no DID token");
//           state.otpError.value = 'Authentication failed';
//           return;
//         }
//
//         // Update userdetails with wallet address and store
//         _userState.didToken.value = result.didToken;
//         final walletAddress = await _magicService.getWalletAddress();
//         L.info("AUTH_VIEW_CONTROLLER", "Wallet auth successful (did=$result.didToken). Updating user details with wallet address: $walletAddress");
//         _userState.userDetails.value = _userState.userDetails.value?.copyWith(walletAddress: walletAddress);
//         await _userApi.updateUserDetails(_userState.userDetails.value!);
//         L.debug("AUTH_VIEW_CONTROLLER", "...Wallet address updated.");
//
//         // Navigate to confirmation screen
//         Get.toNamed($appRoutes.onboarding.avatarRequest);
//
//         break;
//
//       case MagicAuthState.error:
//         L.error("AUTH_VIEW_CONTROLLER", "Auth error: ${result.error}");
//         state.otpError.value = result.error ?? 'Authentication failed';
//         break;
//     }
//   }
// }
