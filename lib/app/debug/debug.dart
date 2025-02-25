import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/modules/lloo_read/controllers/memory_details_view_controller.dart';
import 'package:lloo_mobile/app/modules/lloo_read/models/memory_details_view_model.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_module.dart';
import 'package:lloo_mobile/app/navigation.dart';

import '../app_routes.dart';
import '../modules/lloo_read/services/memories_service.dart';

/// Flags and actions for various debug tasks.

//=======================================================================
// DEBUG ENABLED
//=======================================================================
/// False means all debug features are off. Auto-false for release mode
const bool kDebugEnabled = true && !kReleaseMode;


/// Wrap values below in this to ensure features are off in release mode.
/// Returns null if dbg_enabled is false. Otherwise returns the specified value
T? _x<T>(T? p) => kDebugEnabled ? p : null;


//=======================================================================
// DEBUG FLAGS
//=======================================================================

/// AUTO-SEARCH: Perform the specified search on app launch
String? kDebugAutoSearch = _x(null);//'Tell me about Elon, Zuck and Trump');

/// FORCE SHOW ROUTE/VIEW: Forces a view/screen to show on app launch
String? kDebugForceStartupRoute = null; //_x($appRoutes.onboarding.avatarRequest);

/// Force show a memory details view (bypasses the the above)
String? kDebugMemoryIdToShowOnStartup = _x(null);//'000017db-ff02-4174-a');

/// Auto fill the email reg/auth form
String? kDebugOnboardingEmailAutofill = _x('briquinn@pm.me');
/// Skip the wallet creation on startup
bool kDebugOnboardingSkipWalletCreation = _x(false) ?? false;

//=======================================================================
// DEBUG ACTIONS
// - Keep all enablers and input params above.
//=======================================================================

/// Call this from main to execute anything enabled by the debug flags
Future<void> debugDoStartupMainDebugActions() async {
  if (!kDebugEnabled) return; // extra safety

  if (kDebugMemoryIdToShowOnStartup != null) {
    Get.testMode = true;
    await _doShowMemoryDetailOnStartup(kDebugMemoryIdToShowOnStartup!);
  }
}

//-----------------------------------------------------------------------

Future<void> _doShowMemoryDetailOnStartup(String memId) async {
  L.debug("DEBUG", "Auto-loading memory details view for $memId");
  final memory = await MemoriesService().fetchMemoryById(memId);
  if (memory == null) {
    L.debug("DEBUG", "Memory not found. Skipping auto show details.");
    return;
  }
  L.debug("DEBUG", "Memory loaded: ${memory.json.toString() ?? ''}");

  // Put it with an id for later retrieval

  Future.delayed(Duration(milliseconds: 1000)).then((_) {
    Get.toMemoryDetails(memory);
  });
}

// ---------------------------------------------------------------------

