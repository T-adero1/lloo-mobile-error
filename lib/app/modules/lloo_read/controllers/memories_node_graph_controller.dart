import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';

import '../models/search_results.dart';
import 'force_graph_controller.dart';

class MemoriesNodeGraphController {
  late final ForceGraph3DController _forceGraphController = Get.find();

  MemoriesNodeGraphController();

  void updateData(SearchResultsData? data) {
    if (data == null) return;

    _forceGraphController.updateData(
      nodes: data.memories.map((m) => _memoryToGraphNodeJson(m)).toList(),
      links: data.links.map((l) => _linkToGraphLinkJson(l)).toList(),
    );
  }

  ForceGraph3DController get forceGraphController => _forceGraphController;

  void dispose() {
    _forceGraphController.dispose();
  }

  Map<String, dynamic> _memoryToGraphNodeJson(Memory node) => {
    'id': node.id,
    'name': node.title ?? node.id,
    'val': node.calculatedPrice,
    'color': _getColorForType(node.type),
    'nodeType': node.type.toString(),
    'metadata': {
      'title': node.title,
      'source': node.source,
      'date': getDateTextForResult(node),
      'Calc Price': node.calculatedPrice.toStringAsFixed(2),
      'Target Price': node.targetPrice.toStringAsFixed(2)
    }
  };

  String _getColorForType(MemoryType type) {
    switch(type) {
      case MemoryType.source: return '#FF0000';  // blue
      case MemoryType.category: return '#00FF00'; // green
      case MemoryType.doc: return '#0000FF';   // orange
    }
  }

  Map<String, dynamic> _linkToGraphLinkJson(MemoryLink link) => {
    'source': link.memory1Id,
    'target': link.memory0Id,
    'value': link.totalLockedValue
  };


}
