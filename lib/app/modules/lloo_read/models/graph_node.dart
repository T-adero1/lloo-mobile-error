import "package:lloo_mobile/app/modules/lloo_read/models/search_results.dart";

import "package:lloo_mobile/app/core/models/memory.dart";

class GraphNode {
  final String id;
  final String label;
  final MemoryType type;
  final List<String> connections;

  GraphNode({
    required this.id,
    required this.label,
    required this.type,
    this.connections = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'type': type.toString(),
    'connections': connections,
  };
}
