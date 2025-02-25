// lib/widgets/force_graph/force_graph_view.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controllers/force_graph_controller.dart';

class ForceGraph3DView extends StatefulWidget {
  final ForceGraph3DController controller;
  final Function(Map<String, dynamic>)? onNodeClick;

  const ForceGraph3DView({
    super.key,
    required this.controller,
    this.onNodeClick
  });

  @override
  State<ForceGraph3DView> createState() => _ForceGraph3DViewState();
}

class _ForceGraph3DViewState extends State<ForceGraph3DView> with AutomaticKeepAliveClientMixin {
  bool _isDisposed = false;
  WebViewController? _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller.webController;
    _controller?.addJavaScriptChannel(
      'Flutter',
      onMessageReceived: (message) {
        if (_isDisposed) return;
        final data = jsonDecode(message.message);
        if (data['type'] == 'nodeClick') {
          widget.onNodeClick?.call(data['node']);
        }
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.clearCache();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isDisposed) return const SizedBox();

    return WebViewWidget(
      controller: widget.controller.webController,
    );
  }
}