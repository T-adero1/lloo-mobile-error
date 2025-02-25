import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';

import '../services/memories_service.dart';

enum RelatedMemoriesType { user, topic, related }

class RelatedMemoriesLinks extends StatelessWidget {
  final List<Memory> memories;
  final String title;
  final Function(String memoryId) onMemoryTapped;
  final Function() onMoreTapped;

  final memoriesService = Get.find<MemoriesService>();

  RelatedMemoriesLinks({
    super.key,
    required this.memories,
    required this.title,
    required this.onMemoryTapped,
    required this.onMoreTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: memories.map((memory) {
              return GestureDetector(
                onTap: () => onMemoryTapped(memory.id),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CachedNetworkImage(
                    imageUrl: memory.imageUrl ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => onMoreTapped(),
          child: Text(
            '+${memories.length}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}