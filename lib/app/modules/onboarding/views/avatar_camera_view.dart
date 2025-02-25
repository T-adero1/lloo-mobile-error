import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/core/centered_logo_view_base.dart';
import 'package:lloo_mobile/app/core/widgets/PushedViewNavBar.dart';
import '../controllers/avatar_camera_view_controller.dart';
import '../onboarding_state.dart';
import '../widgets/dotted_circle.dart';
import 'package:lloo_mobile/app/core/widgets/processing_dialog.dart'; // Import the ProcessingDialog widget

class AvatarCameraView extends LlooView<AvatarCameraViewController, OnboardingState> {
  AvatarCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Obx(() => !state.cameraIsInitialized.value
      ? const Center(child: CircularProgressIndicator())
      : Stack(
        children: [
          //=======================================================================
          // Camera Preview
          //=======================================================================
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = 1 / (controller.cameraController.value.aspectRatio * MediaQuery.of(context).size.aspectRatio);
              return Transform.scale(
                scale: scale,
                child: Center(
                  child: CameraPreview(controller.cameraController),
                ),
              );
            },
          ),

          //=======================================================================
          // Dotted circle overlay
          //=======================================================================

          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final circleSize = constraints.maxWidth * 0.8;
                return DottedCircle(
                  width: circleSize,
                  height: circleSize,
                  color: Colors.white,
                  strokeWidth: 2.0,
                );
              },
            ),
          ),

          //=======================================================================
          // Bottom controls
          //=======================================================================

          Obx(() => !controller.isProcessing.value
            ? Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Switch camera button
                  if (controller.cameras.length > 1)
                    IconButton(
                      icon: const Icon(Icons.switch_camera, color: Colors.white, size: 32),
                      onPressed: controller.switchCamera,
                    ),

                  // Take picture button
                  GestureDetector(
                    onTap: controller.takePicture,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Placeholder to maintain centering
                  if (controller.cameras.length > 1)
                    const SizedBox(width: 32, height: 32),
                ],
              ),
            )
            : const SizedBox.shrink()
          ),
        ],
      )
    );
  }
}

class CircleOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4; // Adjust size as needed

    // Create the path for the overlay
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;

    // Draw semi-transparent black overlay
    canvas.drawPath(
      path,
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    // Draw white circle outline
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
