import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LlooLogo extends StatelessWidget {
  final double width;

  const LlooLogo({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      width: width,
      child: SvgPicture.asset(
        'assets/images/lloo_logo.svg',
        width: width,
        fit: BoxFit.contain,
      ),
    );
  }
}