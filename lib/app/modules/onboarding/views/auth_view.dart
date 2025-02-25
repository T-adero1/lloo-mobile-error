// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:lloo_mobile/app/core/centered_logo_view_base.dart';
// import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
// import 'package:lloo_mobile/app/modules/onboarding/controllers/auth_controller.dart';
// import 'package:lloo_mobile/app/modules/onboarding/onboarding_state.dart';
// import '../onboarding_styles.dart';
//
// class AuthView extends CenteredLogoViewBase<AuthViewController, OnboardingState> {
//   AuthView({super.key}) : super(
//       appBar: PushedViewNavBar(hideBottomLine: true),
//       offsetUp: 100,
//   );
//
//   @override
//   Widget buildContent(BuildContext context) {
//     // Initialize magic service with proper context
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.initializeMagicService(context);
//     });
//
//     return Obx(() => AnimatedCrossFade(
//       duration: const Duration(milliseconds: 300),
//       crossFadeState: state.showingOtp.value
//         ? CrossFadeState.showSecond
//         : CrossFadeState.showFirst,
//       firstChild: _buildEmailForm(),
//       secondChild: _buildOtpForm(),
//     ));
//   }
//
//   Widget _buildEmailForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: OnboardingStyles.logoSpacing),
//
//         Text(
//           'Enter your email',
//           style: theme.textTheme.titleMedium?.copyWith(
//             color: theme.colorScheme.secondary
//           ),
//         ),
//
//         SizedBox(height: 8),
//
//         Obx(() => TextField(
//           onSubmitted: (email) => controller.onEmailSubmitted(email),
//           onChanged: (value) => controller.validateEmail(value),
//           textInputAction: TextInputAction.done,
//           style: theme.textTheme.headlineMedium?.copyWith(
//             color: Colors.black,
//           ),
//           controller: controller.emailController,
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(
//             hintText: 'email@example.com',
//             hintStyle: theme.textTheme.headlineMedium?.copyWith(
//               color: theme.colorScheme.secondary.withAlpha(120),
//             ),
//             border: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             errorText: state.emailError.value.isEmpty ? null : state.emailError.value,
//             errorStyle: TextStyle(
//               color: theme.colorScheme.error,
//               fontSize: 14,
//             ),
//           ),
//         )),
//       ],
//     );
//   }
//
//   Widget _buildOtpForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: OnboardingStyles.logoSpacing),
//
//         Text(
//           'Enter the key we\'ve sent you',
//           style: theme.textTheme.titleMedium?.copyWith(
//             color: theme.colorScheme.secondary
//           ),
//         ),
//
//         SizedBox(height: 4),
//
//         SizedBox(
//           width: 230,
//           child: PinCodeTextField(
//             appContext: Get.context!,
//             length: 4,
//             textStyle: theme.textTheme.displaySmall!.copyWith(
//               color: theme.colorScheme.secondary
//             ),
//             onChanged: (value) {},
//             onCompleted: (otp) => controller.onOtpSubmitted(otp),
//             keyboardType: TextInputType.numberWithOptions(
//               signed: false,
//               decimal: false
//             ),
//             backgroundColor: Colors.transparent,
//             animationType: AnimationType.fade,
//             showCursor: true,
//             cursorColor: theme.colorScheme.secondary,
//             cursorWidth: 2,
//             cursorHeight: 30,
//             obscureText: true,
//             blinkWhenObscuring: true,
//             obscuringWidget: Text(
//               '✦',
//               style: theme.textTheme.displaySmall!.copyWith(
//                 color: theme.colorScheme.secondary
//               )
//             ),
//             pinTheme: PinTheme(
//               shape: PinCodeFieldShape.underline,
//               fieldHeight: 50,
//               fieldWidth: 40,
//               activeBorderWidth: 1.5,
//               activeColor: theme.colorScheme.secondary,
//               selectedColor: theme.colorScheme.secondary,
//               inactiveColor: theme.colorScheme.secondary.withAlpha(120),
//             ),
//           ),
//         ),
//
//         SizedBox(height: 16),
//
//         Obx(() => state.otpError.value.isEmpty ? SizedBox() : Text(
//           state.otpError.value,
//           style: TextStyle(
//             color: theme.colorScheme.error,
//             fontSize: 14,
//           ),
//         )),
//       ],
//     );
//   }
// }
