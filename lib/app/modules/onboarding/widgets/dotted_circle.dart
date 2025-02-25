import 'package:flutter/material.dart';
import 'dart:math' as math;

class DottedCircle extends StatelessWidget {
  final double width;
  final double height;
  final double strokeWidth;
  final Color color;
  final bool showPlus;
  final Color? plusColor;
  final double? plusStrokeWidth;

  const DottedCircle({
    super.key,
    required this.width,
    required this.height,
    this.strokeWidth = 2,
    this.color = Colors.white,
    this.showPlus = false,
    this.plusColor,
    this.plusStrokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: DottedCirclePainter(
        strokeWidth: strokeWidth,
        color: color,
        showPlus: showPlus,
        plusColor: plusColor ?? color,
        plusStrokeWidth: plusStrokeWidth ?? strokeWidth,
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final bool showPlus;
  final Color plusColor;
  final double plusStrokeWidth;

  DottedCirclePainter({
    required this.strokeWidth,
    required this.color,
    required this.showPlus,
    required this.plusColor,
    required this.plusStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth;  

    // Draw dotted circle
    final path = Path();
    for (var i = 0; i < 360; i += 6) {
      final x1 = center.dx + radius * math.cos(i * math.pi / 180);
      final y1 = center.dy + radius * math.sin(i * math.pi / 180);
      path.moveTo(x1, y1);
      
      final x2 = center.dx + radius * math.cos((i + 3) * math.pi / 180);
      final y2 = center.dy + radius * math.sin((i + 3) * math.pi / 180);
      path.lineTo(x2, y2);
    }
    canvas.drawPath(path, paint);

    // Draw plus if enabled
    if (showPlus) {
      final plusPaint = Paint()
        ..color = plusColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = plusStrokeWidth;

      final plusSize = radius * 0.3; // Plus size relative to circle

      // Horizontal line
      canvas.drawLine(
        Offset(center.dx - plusSize, center.dy),
        Offset(center.dx + plusSize, center.dy),
        plusPaint,
      );

      // Vertical line
      canvas.drawLine(
        Offset(center.dx, center.dy - plusSize),
        Offset(center.dx, center.dy + plusSize),
        plusPaint,
      );
    }
  }

  @override
  bool shouldRepaint(DottedCirclePainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.showPlus != showPlus ||
        oldDelegate.plusColor != plusColor ||
        oldDelegate.plusStrokeWidth != plusStrokeWidth;
  }
}
