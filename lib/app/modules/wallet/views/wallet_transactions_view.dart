// wallet_transactions_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/modules/user/models/wallet_transaction.dart';
import 'package:lloo_mobile/app/modules/user/services/user_api.dart';

import '../../user/user_state.dart';
import '../utils/transaction_utils.dart';
import '../widgets/wallet_entities_table.dart';
import 'wallet_action_view_base.dart';

class WalletTransactionsView extends WalletActionViewBase {
  final UserApi _userService = Get.find<UserApi>();
  
  WalletTransactionsView({super.key}) : super(
    iconName: 'transfer',
    title: 'Transactions',
  );

  @override
  Widget buildContent(BuildContext context) {
    final userState = Get.find<UserState>();
    
    return Obx(() =>
        WalletEntitiesTable(
            entities: userState.transactionHistory.value,
            rowBuilder: (context, WalletTransaction tx, index) => tableRowFromTransaction(tx)
        ));
  }
}