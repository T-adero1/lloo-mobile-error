import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:convert';

import '../models/graph_node.dart';

class GraphVisualization extends StatefulWidget {
  final List<GraphNode> nodes;
  final Function(String) onNodeTap;
  final Function(String, String) onLinkTap;

  const GraphVisualization({
    Key? key,
    required this.nodes,
    required this.onNodeTap,
    required this.onLinkTap,
  }) : super(key: key);

  @override
  _GraphVisualizationState createState() => _GraphVisualizationState();
}

class _GraphVisualizationState extends State<GraphVisualization> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _updateGraph();
          },
        ),
      )
      ..loadHtmlString(_getHtmlContent());
  }

  void _updateGraph() {
    final graphData = jsonEncode(widget.nodes);
    _controller.runJavaScript('''
      updateGraph($graphData);
    ''');
  }

  String _getHtmlContent() {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <script src="https://d3js.org/d3.v7.min.js"></script>
        <style>
          body { margin: 0; }
          .node { cursor: pointer; }
          .link { cursor: pointer; }
        </style>
      </head>
      <body>
        <svg id="graph" width="100%" height="100%"></svg>
        <script>
          let svg = d3.select("#graph");
          let width = window.innerWidth;
          let height = window.innerHeight;
          
          let simulation = d3.forceSimulation()
            .force("link", d3.forceLink().id(d => d.id))
            .force("charge", d3.forceManyBody().strength(-300))
            .force("center", d3.forceCenter(width / 2, height / 2));

          function getNodeColor(type) {
            switch(type) {
              case 'ResultType.source': return 'red';
              case 'ResultType.channel': return 'green';
              case 'ResultType.result': return 'blue';
              default: return 'gray';
            }
          }

          function updateGraph(data) {
            // Convert data to nodes and links format
            let nodes = data;
            let links = [];
            data.forEach(node => {
              node.connections.forEach(targetId => {
                links.push({
                  source: node.id,
                  target: targetId
                });
              });
            });

            // Clear existing elements
            svg.selectAll("*").remove();

            let link = svg.append("g")
              .selectAll("line")
              .data(links)
              .enter().append("line")
              .attr("class", "link")
              .style("stroke", "#999")
              .style("stroke-width", 1)
              .on("click", (event, d) => {
                window.flutter_inappwebview.callHandler(
                  'onLinkTap', 
                  d.source.id, 
                  d.target.id
                );
              });

            let node = svg.append("g")
              .selectAll("circle")
              .data(nodes)
              .enter().append("circle")
              .attr("class", "node")
              .attr("r", 5)
              .style("fill", d => getNodeColor(d.type))
              .on("click", (event, d) => {
                window.flutter_inappwebview.callHandler(
                  'onNodeTap', 
                  d.id
                );
              });

            simulation
              .nodes(nodes)
              .on("tick", ticked);

            simulation.force("link")
              .links(links);

            function ticked() {
              link
                .attr("x1", d => d.source.x)
                .attr("y1", d => d.source.y)
                .attr("x2", d => d.target.x)
                .attr("y2", d => d.target.y);

              node
                .attr("cx", d => d.x)
                .attr("cy", d => d.y);
            }
          }

          // Handle window resize
          window.addEventListener('resize', () => {
            width = window.innerWidth;
            height = window.innerHeight;
            simulation.force("center", d3.forceCenter(width / 2, height / 2));
            simulation.alpha(1).restart();
          });
        </script>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
