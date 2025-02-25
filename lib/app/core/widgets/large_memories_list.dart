// large_memories_list.dart
import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/app_theme.dart';

import '../../app_styles.dart';
import '../models/memory.dart';

class LargeMemoriesList extends StatelessWidget {
  const LargeMemoriesList({
    super.key,
    required this.memories,
  });

  final List<Memory> memories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: kScreenPaddingSizeLR,
        vertical: 16.0,
      ),
      itemCount: memories.length,
      itemBuilder: (context, index) {
        final memory = memories[index];
        return LargeMemoryCard(memory: memory);
      },
    );
  }
}

class LargeMemoryCard extends StatelessWidget {
  const LargeMemoryCard({
    super.key,
    required this.memory,
  });

  final Memory memory;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Implement the memory card UI
            Text(memory.title ?? ''),
          ],
        ),
      ),
    );
  }
}