
import 'package:flutter/material.dart';

class VerticalVignette extends StatelessWidget {
  final bool isBottomUp;
  final double height;

  const VerticalVignette({
    super.key,
    required this.height,
    this.isBottomUp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isBottomUp ? Alignment.bottomCenter :Alignment.topCenter,
          end: isBottomUp ? Alignment.topCenter : Alignment.bottomCenter,
          colors: [
            Colors.black.withAlpha(127),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
