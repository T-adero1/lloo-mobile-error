import 'package:get/get.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

class WalletApi extends GetxService {
  final Magic _magic = Get.find();

  WalletApi();

  /// Auths and gets the wallet address, creating on if none. Does the OTP popup.
  Future<String?> fetchWalletAddress(String email) async {
    try {
      L.info("WALLET_API", "Fetching wallet address for email $email");
      var token = await _magic.auth.loginWithEmailOTP(email: email);
      L.debug("WALLET_API", "loginWithEmailOTP completed with token: ${token?.substring(0, 10)}...");
      L.debug("WALLET_API", "About to call getInfo...");
      final metadata = await _magic.user.getInfo();
      L.debug("WALLET_API", "...success. Wallet = ${metadata.toString()}");
      return metadata.publicAddress;
    } catch (e, stackTrace) {
      L.error("WALLET_API", "Magic link error: $e\nStack trace: $stackTrace");
      // @TODO: #hi-p — Re-throw in our DSL
      return null;
    }
  }

  Future<void> logoutWallet() async {
    try {
      await _magic.user.logout();
    } catch (e) {
      L.error("USER_SERVICE", "Magic logout error: $e");
      // @TODO: #hi-p - Re-throw in our DSL
      return;
    }
  }
}
