import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/modules/lloo_read/models/memory_details_view_model.dart';
import 'package:lloo_mobile/app/navigation.dart';
import '../lloo_read_state.dart';

import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;



enum RelatedMemoryType {
  user,
  topic,
  related
}


class MemoryDetailsViewController extends LlooViewController<LlooReadState> {
  Memory? memory;
  late MemoryDetailsViewModel model;

  @override
  void onInit() {
    super.onInit();

    // Get the specific memory from the DI
    memory = Get.find<Memory>(tag:Get.arguments);
    if (memory == null) {
      L.error("MemoryDetailsViewController", "Memory with id ${Get.arguments} does not exist. Shouldnt be.");
    }

    model = MemoryDetailsViewModel(memory: memory!);

    // @TODO:
    // Get the other async parts of the vm loading
    // how to cache widget
    // Try to get the memory from the

    // Get the various additional bits loading
  }

  @override
  void onClose() {
    // Cleanup our memory cache
    Get.readyToLeaveMemoryDetails(memory: memory!);
    super.onClose();
  }

  void handleRelatedMemoryTapped(String memoryId) {
  }

  void handleRelatedMoreTapped(RelatedMemoryType type) {
  }
}
