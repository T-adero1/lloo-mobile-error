import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import '../models/search_results.dart';

class ForceGraph3DController {
  late final WebViewController webController;
  bool _isInitialized = false;

  ForceGraph3DController() {
    if (!_isInitialized) {
      webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)  // @TODO: Pass in theme bg color from app level DSL
        ..loadHtmlString(_buildHtml())
        ..addJavaScriptChannel(
          'GraphReady',
          onMessageReceived: (_) {
            // Graph is ready, we can update data if needed
          },
        );
      _isInitialized = true;
    }
  }

  void dispose() {
    webController.clearCache();
    // Add any other cleanup needed
  }


  //@TODO: remove dependency on Memory. I.e. have this be a standalone widget
  Future<void> updateData({
    required List<Map<String, dynamic>> nodes,
    required List<Map<String, dynamic>> links
  }) async {

    final graphData = {
      'nodes': nodes,
      'links': links
    };


    await webController.runJavaScript('''
      if (typeof graph !== 'undefined') {
        graph.graphData(${jsonEncode(graphData)});
      }
    ''');
  }


  String _buildHtml() => '''
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          * { user-select: none; }
          body { 
            margin: 0; 
            background-color: white; 
            overflow: hidden;
            touch-action: none;
          }
          #3d-graph { 
            width: 100vw; 
            height: 100vh;
            touch-action: none;
          }
        </style>
        <script src="https://unpkg.com/3d-force-graph"></script>
      </head>
      <body style="background-color: #FFFFFF;">
        <div id="3d-graph"></div>
        <script>
          let graph;
          let initialPinchDistance = null;
          let cameraDist = 400;
          
          function initGraph() {
            graph = ForceGraph3D()(document.getElementById('3d-graph'))
              .graphData({nodes: [], links: []})
              .enableNodeDrag(false)
              .showNavInfo(false)
              .backgroundColor('white')
              // .nodeThreeObject(node => { // no worky
              //   const geometry = new THREE.SphereGeometry(1);
              //   const material = new THREE.MeshPhongMaterial({
              //     color: node.color || 'red',
              //     shininess: 100,
              //     transparent: false,
              //     opacity: 1
              //   });
              //   const mesh = new THREE.Mesh(geometry, material);
              //   mesh.scale.setScalar(node.val || 5);
              //   return mesh;
              // })
              .nodeLabel('name')
              .nodeColor(node => node.color)
              .nodeVal('val')
              .nodeRelSize(10) 
              .d3VelocityDecay(0.7) // More sluggish movement
              // .cooldownTime(5000) // Longer animation time
              // .d3Force('charge', d3.forceManyBody().strength(-100)) // Less repulsion
              // .d3Force('link').distance(150) // More space between nodes
              .linkColor(() => 'grey')
              .linkWidth(link => {
                return 1.0;//link.value / 6.0 + 2.0;
              })
              .linkOpacity(0.5)
              .onNodeClick(node => {
                Flutter.postMessage(JSON.stringify({
                  type: 'nodeClick',
                  node: node.metadata
                }));
              });
              
            // const controls = graph.controls();
            // controls.enableKeys = false;
            // controls.enableDamping = true;
            // controls.dampingFactor = 0.25;
            // controls.rotateSpeed = 0.5;        // Reduced from 1.0
            // controls.zoomSpeed = 0.5;          // Reduced from 1.0
            // controls.enabled = true;
            // controls.enableZoom = true;
            // controls.enableRotate = true;
            // controls.enablePan = false;
            // controls.minDistance = 200;        // Set minimum zoom level
            // controls.maxDistance = 2000;       // Set maximum zoom level
            
            // Set initial camera position
            // const currentPosition = graph.camera().position;
            // graph.cameraPosition({
            // });
            
            // Add auto-rotation
            let angle = 0;
            setInterval(() => {
              // const yPos = graph.camera().position.y;
              graph.cameraPosition({
                x: cameraDist * Math.sin(angle),
                z: cameraDist * Math.cos(angle)
              });
              angle += 0.003;  // adjust speed by changing this value (smaller = slower)
            }, 10);
                        
            GraphReady.postMessage('ready');
          }

          // function getDistance(touch1, touch2) {
          //   const dx = touch1.clientX - touch2.clientX;
          //   const dy = touch1.clientY - touch2.clientY;
          //   return Math.sqrt(dx * dx + dy * dy);
          // }
          //
          // document.addEventListener('touchstart', function(e) {
          //   if (e.touches.length === 2) {
          //     initialPinchDistance = getDistance(e.touches[0], e.touches[1]);
          //   }
          // }, { passive: true });
          //
          // document.addEventListener('touchmove', function(e) {
          //   if (e.touches.length === 2 && initialPinchDistance !== null) {
          //     const currentDistance = getDistance(e.touches[0], e.touches[1]);
          //     const distanceRatio = currentDistance / initialPinchDistance;
          //    
          //     // Calculate new zoom with dampened effect
          //     const zoomDelta = (distanceRatio - 1) * 100;
          //     currentZoom = Math.max(200, Math.min(2000, currentZoom - zoomDelta));
          //    
          //     // Update camera position
          //     const currentPos = graph.cameraPosition();
          //     graph.cameraPosition({
          //       x: currentPos.x,
          //       y: currentPos.y,
          //       z: currentZoom
          //     });
          //    
          //     initialPinchDistance = currentDistance;
          //   }
          // }, { passive: true });
          //
          // document.addEventListener('touchend', function() {
          //   initialPinchDistance = null;
          // }, { passive: true });

          // Initialize when everything is loaded
          window.addEventListener('load', initGraph);
        </script>
      </body>
    </html>
  ''';


}