
import 'package:flutter/widgets.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';


class MemoryInfoMini extends StatelessWidget {
  final Memory memory;

  const MemoryInfoMini({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 50, height: 30, child: Placeholder());
  }
}
