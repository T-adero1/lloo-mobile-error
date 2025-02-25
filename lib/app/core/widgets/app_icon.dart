import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  final String name;
  final double? size;
  final Color? color;

  const AppIcon(this.name, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/icon_$name.svg',
      width: size ?? 24,
      height: size ?? 24,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).iconTheme.color!,
        BlendMode.srcIn,
      ),
    );
  }
}