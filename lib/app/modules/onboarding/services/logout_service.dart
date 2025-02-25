import 'package:get/get.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_module.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

class LogoutService extends GetxService {
  final UserState _userState = Get.find<UserState>();

  Future<void> doLogout() async {
    L.info("LOGOUT", "Logging out...");
    try {
      // TODO: Call userApi logout when implemented
      // await userApi.logout();
      
      // Reset user state
      _resetUserState();
      
    } catch (e) {
      L.error("LOGOUT", "Error during logout: $e");
      // Still try to reset state and navigate even if API call fails
      _resetUserState();
    }
  }

  void _resetUserState() {
    _userState.userDataStatus.value = UserDataStatus.initializing;
    _userState.userDetails.value = null;
    _userState.didToken.value = null;
    _userState.attnHoldings.value = null;
    _userState.stakedMemories.clear();
    _userState.linkedMemories.clear();
    _userState.transactionHistory.clear();
    _userState.createdMemories.clear();
    _userState.userStakings.clear();
  }
}
