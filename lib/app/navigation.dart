// navigation_observer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'core/models/memory.dart';
import 'modules/lloo_read/lloo_read_state.dart';

extension LlooNavigation on GetInterface {
  // Navigates to the memory details view and returns clean up function
  void toMemoryDetails(Memory memory) {
    L.info("NAV", "Going to Mem Details. Adding tagged memory ${memory.id} to DI");
    Get.put(memory, tag: memory.id, permanent: true);
    Get.toNamed('/memory', arguments: memory.id);
  }

  // Call on the
  void readyToLeaveMemoryDetails({required Memory memory}) {
    L.info("NAV", "Leaving Mem Details. Deleting memory ${memory.id}");
    Get.delete<Memory>(tag: memory.id, force: true);
  }
}

class LlooNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  void _handleNavigation(Route<dynamic>? route) {
    Get.deleteAll();  // @TODO: Better way to handle this. Views need to clean themselves up when state resets
    if (route?.settings.name == '/home') {
      L.info('NAV', 'Navigated to home - resetting LlooReadState');
      try {
        final state = Get.find<LlooReadState>();
        state.reset();
      } catch (e) {
        L.error('NAV', 'Failed to reset state: $e');
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleNavigation(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _handleNavigation(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _handleNavigation(newRoute);
  }
}
