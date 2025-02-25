
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lloo_read_styles.dart';

class PriceGraphMini extends StatelessWidget {
  const PriceGraphMini({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PriceGraphMiniPainter(),
    );
  }
}



class PriceGraphMiniPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final theme = Theme.of(Get.context!);

    final paint = Paint()
      ..color = theme.colorScheme.tertiary
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    final random = Random(DateTime.now().microsecondsSinceEpoch);  // Fixed seed for consistent results
    double lastY = 0.5;

    for (double x = 0.1; x <= 1.0; x += 0.1) {
      // Generate random movement between -0.15 and 0.15
      double variation = (random.nextDouble() - 0.5) * 0.3;
      // Keep within bounds 0.2 to 0.8
      lastY = (lastY + variation).clamp(0.2, 0.8);

      path.lineTo(
          size.width * x,
          size.height * lastY
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}