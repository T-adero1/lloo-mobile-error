import 'package:get/get.dart';
import 'package:lloo_mobile/app/modules/wallet/controllers/wallet_view_controller.dart';
import 'package:lloo_mobile/app/modules/wallet/services/wallet_service.dart';
import 'package:lloo_mobile/app/modules/wallet/wallet_state.dart';
import 'package:lloo_mobile/app/modules/wallet/views/holdings_view.dart';
import 'package:lloo_mobile/app/modules/wallet/views/wallet_main_view.dart';
import 'package:lloo_mobile/app/modules/wallet/views/token_link_create_view.dart';
import 'package:lloo_mobile/app/modules/wallet/views/wallet_links_view.dart';
import 'package:lloo_mobile/app/modules/wallet/views/wallet_transactions_view.dart';
import 'package:lloo_mobile/app/modules/wallet/views/wallet_transfer_view.dart';
import 'package:lloo_mobile/app/modules/wallet/views/wallet_memories_view.dart';

import '../../app_routes.dart';

// ======================================================================
// MODULE DEPENDENCIES
// ======================================================================
class WalletBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletService());
    Get.lazyPut(() => WalletMainView());
    Get.lazyPut(() => HoldingsView());
    Get.lazyPut(() => TokenLinkCreateView());
    Get.put(WalletViewController(), permanent: true);
    Get.lazyPut(() => WalletLinksView());
    Get.lazyPut(() => WalletTransactionsView());
    Get.lazyPut(() => WalletTransferView());
    Get.lazyPut(() => WalletMemoriesView());
  }
}

// ======================================================================
// ROUTES
// =======================================================================
extension WalletRoutes on AppRoutes {
  get wallet => (
    main: "/wallet",
    holdings: "/wallet/holdings",
    links: "/wallet/links",
    linkCreate: "/wallet/links/create",
    transactions: "/wallet/transactions",
    transfer: "/wallet/transfer",
    memories: "/wallet/memories",
  );
}

void registerRoutes() {
  Get.lazyPut(() => WalletService());
  
  final routes = [
    GetPage(
      name: $appRoutes.wallet.main,
      page: () => WalletMainView(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: $appRoutes.wallet.holdings,
      page: () => HoldingsView(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: $appRoutes.wallet.links,
      page: () => WalletLinksView(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: $appRoutes.wallet.linkCreate,
      page: () => TokenLinkCreateView(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: $appRoutes.wallet.transactions,
      page: () => WalletTransactionsView(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: $appRoutes.wallet.transfer,
      page: () => WalletTransferView(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: $appRoutes.wallet.memories,
      page: () => WalletMemoriesView(),
      binding: WalletBindings(),
    ),
  ];

  $appRoutes.registerRoutes(routes);
}

// ======================================================================
// MODULE INIT
// ======================================================================
void walletModuleInit() {
  // STATE: Make this global and immediately available
  Get.put(WalletState(), permanent: true); // keep state between routings
  
  registerRoutes();
}
