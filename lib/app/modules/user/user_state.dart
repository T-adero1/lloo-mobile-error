import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/core/services/autopersistence.dart';
import 'package:lloo_mobile/app/modules/user/models/wallet_transaction.dart';
import 'models/user_details.dart';

/// Designates status related to user restoration on launch
enum UserDataStatus {
  initializing, newUser, loading, noWallet, ready, error;

  bool isNewUser() => this == UserDataStatus.newUser;
}


class UserState {
  /// We need this to save/restore the rest of the users info
  final userDataStatus = UserDataStatus.initializing.obs;
  final userDetails = Rx<UserDetails?>(null).autopersist('user/user_details');

  final didToken = Rx<String?>(null);
  final attnHoldings = Rx<double?>(null);
  final stakedMemories = RxList<Memory>([]);
  final linkedMemories = RxList<MemoryLink>([]);
  final transactionHistory = RxList<WalletTransaction>([]);
  final createdMemories = RxList<Memory>([]);  // their submitted memories

  // TEMP
  // @TODO: Make the screen using this use the one above
  final userStakings = RxList<Map<String, dynamic>>([
    {'title': 'Alex Brody', 'token': 'GAZATYK', 'amount': 20000},
    {'title': 'Alex Brody', 'token': 'GAZATYK', 'amount': 20000},
    {'title': 'Alex Brody', 'token': 'GAZATYK', 'amount': 20000},
  ]);


  void clearUserData() {
    userDetails.value = null;
    attnHoldings.value = null;
    stakedMemories.clear();
    createdMemories.clear();
    linkedMemories.clear();
    transactionHistory.clear();
    userStakings.clear();
  }
}
