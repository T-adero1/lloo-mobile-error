
// @TODO Make it clip the top/bottom
import 'package:flutter/material.dart';

class NumberBubble extends StatelessWidget {
  final String number;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;

  const NumberBubble({
    super.key,
    required this.number,
    this.backgroundColor,
    this.textColor,
    this.width = 24,
    this.height = 10, // Default truncated height
  });


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
