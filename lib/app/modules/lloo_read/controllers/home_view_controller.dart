import 'package:get/get.dart';
import '../../../debug/debug.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import '../lloo_read_state.dart';

import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;



class HomeViewController extends LlooViewController<LlooReadState> with GetxServiceMixin {

  @override
  void onInit() {
    super.onInit();

    // Does not work, Handled in NavigationObserver
    // ever(Get.routing.current.obs, (route) {
    //   L.debug("SEARCH", "Route $route");
    //
    //   if (route == '/home') {
    //     state.reset();
    //   }
    // });
  }


  @override
  void onReady() {
    super.onReady();
    if (kDebugAutoSearch != null) {
      onSubmitted(kDebugAutoSearch!);
    }
  }

  void onResumed() {  // Change to onResumed
    L.info('SEARCH', "Resuming - clearing state");
    state.reset();
  }

  void onSubmitted(String value) {
    L.info('SEARCH', "Search query submitted: $value");
    state.query.value = value;
    Get.toNamed("/search");
  }
}