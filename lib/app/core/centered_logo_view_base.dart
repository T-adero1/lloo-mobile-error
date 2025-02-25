import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import 'package:lloo_mobile/app/core/widgets/lloo_logo.dart';
import 'package:magic_sdk/magic_sdk.dart';

/// @deprecated.
/// @TODO Just use the VerticallyCenteredViewBase and handle logo manually each time
abstract class CenteredLogoViewBase<C extends LlooViewController, State> extends LlooView<C, State> {
  final PreferredSizeWidget appBar;
  final double offsetUp;

  CenteredLogoViewBase({
    super.key,
    required this.appBar,
    this.offsetUp = 0.0   // @TODO: this is not a good fudge factor. figure out why it isnt centered on its own
  });

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(
              left: kScreenPaddingSizeLR,
              right: kScreenPaddingSizeLR,
              bottom: offsetUp * 2.0
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LlooLogo(width: kLlooLogoWidth),
              SizedBox(height: 4),
              buildContent(context),
            ],
          ),
        ),
      ),
    );
  }
}
