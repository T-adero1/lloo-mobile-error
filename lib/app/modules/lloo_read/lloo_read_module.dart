

import 'package:get/get.dart';
import 'package:lloo_mobile/app/modules/lloo_read/models/memory_details_view_model.dart';
import 'package:lloo_mobile/app/modules/lloo_read/services/memories_service.dart';
import 'package:lloo_mobile/app/app_routes.dart';

import 'controllers/force_graph_controller.dart';
import 'lloo_read_state.dart';
import 'views/home_view.dart';
import 'views/search_results_view.dart';
import 'views/memory_details_view.dart';
import 'controllers/memory_details_view_controller.dart';
import 'controllers/search_results_view_controller.dart';
import 'controllers/home_view_controller.dart';
import 'services/search_service.dart';
import 'widgets/stage_progress_widget.dart';

// ======================================================================
// MODULE BINDINGS

class LlooReadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeView());
    Get.lazyPut(() => HomeViewController(), fenix: true);

    Get.lazyPut(() => SearchResultsView());
    Get.lazyPut(() => SearchResultsViewController(), fenix: true);
    Get.lazyPut(() => ForceGraph3DController(), fenix: true);

    // Multiple simultaneous view instances required for these so
    // create anew each time. We can cache them later with Get.put(tag:memoryId)
    Get.lazyPut(() => MemoryDetailsView());
    Get.lazyPut(() => MemoryDetailsViewController(), fenix: true);
    
    Get.lazyPut(() => SearchService(), fenix: true);
    Get.lazyPut(() => MemoriesService(), fenix: true);
    Get.lazyPut(() => StageProgressWidgetController(), fenix: true);
  }
}


//=======================================================================
// ROUTES
//=======================================================================

extension LlooReadRoutes on AppRoutes {
  get llooRead => (
    home: "/home",
    search: "/search",
    memory: "/memory",
  );
}

//=======================================================================
// MODULE INITIALIZER
//=======================================================================

void llooReadModuleInit() {
  // INIT STATE: Let it be global from the start
 Get.put(LlooReadState(), permanent: true); // keep state between routings

  $appRoutes.registerRoutes([
    GetPage(
      name: $appRoutes.llooRead.home,
      page: () => Get.find<HomeView>(),
      binding: LlooReadBinding(),
    ),
    GetPage(
      name: $appRoutes.llooRead.search,
      page: () => Get.find<SearchResultsView>(),
      binding: LlooReadBinding(),
    ),
    GetPage(
      name: $appRoutes.llooRead.memory,
      // Try to find a cached version using the memory id. See
      page: () {
        final x = Get.find<MemoryDetailsView>();
        return x;
      },
      binding: LlooReadBinding(),
    ),

  ]);
}
