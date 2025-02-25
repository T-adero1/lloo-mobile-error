import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/modules/user/models/user_details.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

import '../models/wallet_transaction.dart';
import 'user_api.dart';

class UserRestorationService {
  final _userState = Get.find<UserState>();
  final _userApi = Get.find<UserApi>();

  UserRestorationService();

  // Must call this before anything that depends on UserState::userDataStatus (e.g. launch route)
  void initializeUserDataStatus() {
    if (_userState.userDetails.value == null) {
      L.info("USER_RESTORATION_SERVICE", "No user data to restore. Hopefully it's a new user.");
      _userState.userDataStatus.value = UserDataStatus.newUser;
      return;
    } else {
      L.info("USER_RESTORATION_SERVICE", "User details restored from local for user ${_userState.userDetails.value!.userId}");
    }
  }

  // @TODO: Handle connectivity and deferred restoration
  // @TODO: Handle error and retrying (generically?)
  Future<void> restoreUserDataAsync() async {
    if (_userState.userDetails.value == null) {
      L.info("USER_RESTORATION_SERVICE", "No user data to restore.");
      return;
    }
    return await _restoreUserData();
  }

  Future<void> _restoreUserData() async {
    // Since we checked before then this should never occur
    if (_userState.userDetails.value == null) {
      throw StateError("Trying to restore a new user. Shouldnt have come here");
    }

    L.info("USER_RESTORATION_SERVICE", "Restoring user data for user ${_userState.userDetails.value!.userId}");

    try {
      // Indicate the state throughout
      _userState.userDataStatus.value = UserDataStatus.loading;

      final userId = _userState.userDetails.value!.userId;

      // Load everything in parallel
      // NOTE: this will all change
      final results = await Future.wait([
        _userApi.fetchDetails(userId),
        _userApi.fetchHoldings(userId),
        _userApi.fetchTransactionHistory(userId)
      ]);

      final userDetails = results[0] as UserDetails?;
      final holdings = results[1] as Map<String, dynamic>?;
      final transactions = results[2] as List<WalletTransaction>?;

      _userState.userDetails.value = userDetails;
      _userState.attnHoldings.value = holdings?['attnHoldings'] as double?;
      _userState.stakedMemories.value =
          (holdings?['stakedMemories'] as List<Memory>?) ?? <Memory>[];
      _userState.linkedMemories.value =
          (holdings?['linkedMemories'] as List<MemoryLink>?) ?? <MemoryLink>[];
      _userState.createdMemories.value =
          (holdings?['createdMemories'] as List<Memory>?) ?? <Memory>[];
      _userState.transactionHistory.value =
          transactions ?? <WalletTransaction>[];

      // Check for walletAddress and set status accordingly
      if (_userState.userDetails.value!.walletAddress == null) {
        L.warn("USER_RESTORATION_SERVICE", "User restored but has no wallet address");
        _userState.userDataStatus.value = UserDataStatus.noWallet;
      } else {
        L.debug("USER_RESTORATION_SERVICE", "User fully restored (has wallet addr)");
        _userState.userDataStatus.value = UserDataStatus.ready;
      }

    } catch (e) {
      L.error("USER_RESTORATION_SERVICE", "Error restoring user data: $e");
      _userState.userDataStatus.value = UserDataStatus.error;
      rethrow;
    }
  }
}