
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';

/// Just for the memory details view. Depends on LlooReadState
class MemoryDetailsHeaderImage extends StatelessWidget {
  final Memory memory;

  const MemoryDetailsHeaderImage({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenWidth),
      child: CachedNetworkImage(
        imageUrl: memory.imageUrl ?? '',
        fit: BoxFit.cover, // use cover to fill the space while preserving aspect ratio
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      ),
    );
  }
}
