import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/modules/lloo_read/lloo_read_module.dart';
import 'package:lloo_mobile/app/modules/onboarding/services/logout_service.dart';
import '../wallet_state.dart';

// @TODO: Are we doign one VC per view or sharing?
// ...I think the former with a non-V controller for carried over tasks.
// But I also state should cover that as much as possible
class WalletViewController extends LlooViewController<WalletState> {
  final LogoutService _logoutService = Get.find<LogoutService>();

  WalletViewController();

  Future<void> onLogoutTapped() async {
    Get.snackbar("", "Logging out...");
    _logoutService.doLogout().then((_) {});
    // Pop back to home
    Get.until((route) => route.settings.name == $appRoutes.llooRead.home); // @TODO: #med-p Find a cleaner way
  }
}
