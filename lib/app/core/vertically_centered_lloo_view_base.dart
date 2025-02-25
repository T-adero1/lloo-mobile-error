import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import 'package:lloo_mobile/app/core/widgets/lloo_logo.dart';

abstract class VerticallyCenteredLlooViewBase<C extends LlooViewController, State> extends LlooView<C, State> {
  final PreferredSizeWidget? _appBar;
  PreferredSizeWidget? get appBar => _appBar;// ?? PushedViewNavBar();
  // final double offsetUp;
  
  VerticallyCenteredLlooViewBase({
    super.key,
    PreferredSizeWidget? appBar,
    // this.offsetUp = 0.0   // @TODO: this is not a good fudge factor. figure out why it isnt centered on its own
  }) : _appBar = appBar;

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
            // bottom: offsetUp * 2.0
          ),
          child: buildContent(context),
        ),
      ),
    );
  }
}
