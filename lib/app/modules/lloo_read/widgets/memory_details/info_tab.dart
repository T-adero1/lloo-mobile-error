



import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/memory_details_view_controller.dart';
import '../../models/memory_details_view_model.dart';
import '../related_memories_widget.dart';

class InfoTab extends StatelessWidget {
  final MemoryDetailsViewModel viewModel;
  final MemoryDetailsViewController controller;

  InfoTab({super.key, required this.viewModel, required this.controller});

  @override
  Widget build(BuildContext context) {
    final memory = viewModel.memory;
    final theme = Theme.of(context);

    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(memory.value.description ?? '', style: theme.textTheme.labelMedium),
          ),

          if (viewModel.linkedMemoriesByUser.value != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: RelatedMemoriesLinks(
                  title: 'More from this user',
                  memories: viewModel.linkedMemoriesByUser.value!,
                  onMemoryTapped: (memoryId) => controller.handleRelatedMemoryTapped(memoryId),
                  onMoreTapped: () => controller.handleRelatedMoreTapped(RelatedMemoryType.user)
              ),
            ),


          if (viewModel.linkedMemoriesByTopic.value != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: RelatedMemoriesLinks(
                  title: 'More from Gaza',  // @TODO: How to get this topic
                  memories: viewModel.linkedMemoriesByUser.value!,
                  onMemoryTapped: (memoryId) => controller.handleRelatedMemoryTapped(memoryId),
                  onMoreTapped: () => controller.handleRelatedMoreTapped(RelatedMemoryType.topic)
              ),
            ),


          if (viewModel.linkedMemoriesByRelated.value != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: RelatedMemoriesLinks(
                  title: 'Related',
                  memories: viewModel.linkedMemoriesByUser.value!,
                  onMemoryTapped: (memoryId) => controller.handleRelatedMemoryTapped(memoryId),
                  onMoreTapped: () => controller.handleRelatedMoreTapped(RelatedMemoryType.related)
              ),
            ),
        ],
      ),
    );
  }
}
