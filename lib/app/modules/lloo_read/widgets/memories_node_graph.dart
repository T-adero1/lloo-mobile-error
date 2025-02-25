
import 'package:flutter/material.dart';
import '../models/search_results.dart';
import '../controllers/memories_node_graph_controller.dart';
import '../controllers/force_graph_controller.dart';
import 'force_graph/force_graph_view.dart';
import 'force_graph/node_details_overlay.dart';

class MemoriesNodeGraph extends StatefulWidget {
  final MemoriesNodeGraphController controller;

  const MemoriesNodeGraph({
    super.key,
    required this.controller
  });

  @override
  State<MemoriesNodeGraph> createState() => _MemoriesNodeGraphState();
}

class _MemoriesNodeGraphState extends State<MemoriesNodeGraph> {
  // final _graphController = ForceGraph3DController();
  Map<String, dynamic>? _selectedNode;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _updateGraph();
  // }
  //
  // @override
  // void dispose() {
  //   _graphController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void didUpdateWidget(MemoriesNodeGraph oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.resultsData != oldWidget.resultsData) {
  //     _updateGraph();
  //   }
  // }
  //
  // void _updateGraph() {
  //   if (widget.resultsData == null) return;
  //   _graphController.updateData(
  //     nodes: widget.resultsData?.memories ?? [],
  //     links: widget.resultsData?.links ?? []
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ForceGraph3DView(
          controller: widget.controller.forceGraphController,
          onNodeClick: (nodeData) {
            setState(() => _selectedNode = nodeData);
          },
        ),

        if (_selectedNode != null)
          Positioned(
            top: 16,
            right: 16,
            child: NodeDetailsOverlay(node: _selectedNode!),
          ),
      ],
    );
  }
}