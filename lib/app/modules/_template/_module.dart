import 'package:get/get.dart';

class MyModuleBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<SearchController>(() => SearchController());
    // Get.lazyPut<SearchService>(() => SearchService());
    // Get.lazyPut<StageProgressWidgetController>(() => StageProgressWidgetController());
  }
}


// ======================================================================
// MODULE INITIALIZER

void myModuleInit() {
  // INIT STATE: Let it be global from the start
  // Get.put(LlooReadState(), permanent: true); // keep state between routings

  // $appRoutes.registerRoutes([
  //   GetPage(
  //       name: "/home",
  //       page: () => HomeView(),
  //       binding: LlooReadBinding(),
  //   ),
  //   GetPage(
  //       name: "/search",
  //       page: () => SearchResultsView(),
  //       binding: LlooReadBinding(),
  //   ),
  // ]);
}