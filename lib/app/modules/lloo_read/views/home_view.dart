import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/widgets/lloo_navbar.dart';
import 'package:lloo_mobile/app/core/centered_logo_view_base.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import '../controllers/home_view_controller.dart';
import '../lloo_read_state.dart';

class HomeView extends CenteredLogoViewBase<HomeViewController, LlooReadState> {
  HomeView({super.key}) : super(
    appBar: LlooNavbar(hideLogo: true),
    offsetUp: 80,
  );

  final TextEditingController _controller = TextEditingController();

  @override
  Widget buildContent(BuildContext context) {
    return Column(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: controller.onSubmitted,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.headlineLarge,
              controller: _controller,
              maxLines: null, // This allows auto-expansion
              minLines: 1,   // Start with 1 line
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: 600, // Fixed width - adjust this value as needed
                ),
                hintText: 'Search & promote\nyour truth...',
                hintStyle: theme.textTheme.headlineLarge!.copyWith(color: theme.colorScheme.secondary.withAlpha(200)), // Fade it a bit more
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                filled: false,
                isDense: true,  // Add this
                contentPadding: EdgeInsets.only(top: 16),
              ),
            ),
          ],
        );
  }
}
