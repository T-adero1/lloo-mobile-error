import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/modules/lloo_read/widgets/stage_progress_widget.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/navigation.dart';
import '../lloo_read_state.dart';
import '../models/search_results.dart';
import '../models/search_stage.dart';
import '../services/search_service.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/navigation.dart';
import 'memories_node_graph_controller.dart';

class SearchResultsViewController extends LlooViewController<LlooReadState> {
  final StageProgressWidgetController progressWidgetController = Get.find();

  final MemoriesNodeGraphController graphController = MemoriesNodeGraphController();


  final SearchService _searchService = Get.find<SearchService>();
  Stream<SearchResultsData>? _resultsStream;

  /// Begin the search when the widget appears
  @override
  void onReady() {
    super.onReady();

    // Ensure we have a query, else we shouldn't be here really
    if (state.query.value.isEmpty) {
      // @TODO Custom error handling
      throw Exception('No query provided');
    }

    // Setup listeners on stage to update widget controller
    ever(state.resultsData, (resultsData) {
      if (resultsData == null) return;
      progressWidgetController.value = resultsData.stage;
      graphController.updateData(resultsData);  // Update graph when data changes
    });

    // All done is we're already searching (and this is resurrected controller)
    if (state.hasBegunSearch.value == true) {
      // this is okay as we may have viewed a memory and have come back
      L.info("SEARCH", "Controller onReady called when search already in progress.");
      return;
    }

    // Initiate the search and listen for response
    L.info('SEARCH', "Initiating the search...");
    state.hasBegunSearch.value = true;
    _searchService.query(state.query.value).then( (stream) {
      _resultsStream = stream
        ..listen((result) {
          if (result.stage == SearchStage.produce) {
            L.info("SEARCH", "Done.");
            // @TODO: Does this stream never actually complete??
          }

          L.info("SEARCH", """Results received at stage ${result.stage.toString()}. 
Memory count: $result.memories.length
Used count: ${result.memoriesUsed?.length ?? 0}
""");
          // L.debug("SEARCH", result.documentTypeMemories?.first.toString() ?? 'no docs');

          L.debug("SEARCH", "Setting state with new results $result");
          state.resultsData.value = result;

        },
            onDone: () {
              L.info("SEARCH", "Done! Cue2Lit Search complete.");
              // @TODO: Never called!
            });

    });
  }

  @override
  void dispose() {
    L.info("SEARCH", "Disposing SearchResultsController");
    _searchService.cancel();
    _resultsStream = null;
    super.dispose();
  }
  @override
  void onClose() {
    super.onClose();
  }


  /// Handle when a memory is tapped from the search results list.
  ///
  /// This causes the memory details view to be pushed onto the stack.
  void handleMemoryTapped(Memory memory) {
    Get.toMemoryDetails(memory);
  }

}