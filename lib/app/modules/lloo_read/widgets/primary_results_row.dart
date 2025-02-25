import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/modules/lloo_read/widgets/price_graph_mini.dart';
import 'package:lloo_mobile/app/app_theme.dart';

import '../../../app_styles.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import '../lloo_read_styles.dart';
import '../models/search_results.dart';
import 'price_info_mini.dart';

class PrimaryResultsRow extends StatelessWidget {
  final List<Memory> memories;
  final double cardWidth;
  final double cardHeight;
  final void Function(Memory)? onMemoryTapped;

  const PrimaryResultsRow({
    super.key,
    required this.memories,
    required this.cardWidth,
    required this.cardHeight,
    this.onMemoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          memories.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              // L/R pad the scroller or the spacing between cards
              left: index == 0 ? kScreenPaddingSizeLR : 3,
              right: index == memories.length - 1 ? kScreenPaddingSizeLR : 3,
            ),
            child: InkWell(
              onTap: onMemoryTapped != null ? () => onMemoryTapped!(memories[index]) : null,
              child: PrimaryResultCard(
                memory: memories[index],
                number: '${index + 1}',
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//=======================================================================
// CARD
//=======================================================================

class PrimaryResultCard extends StatelessWidget {
  final Memory memory;
  final String number;
  final double cardWidth;
  final double cardHeight;

  const PrimaryResultCard({
    super.key,
    required this.memory,
    required this.number,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          // Background image
          CachedNetworkImage(
            imageUrl: memory.imageUrl ?? '',
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Gradient overlay
          // @TODO: replace with widget
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(25),
                  Colors.black.withAlpha(180),
                ]
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //=======================================================================
                      // NUMBER
                      //=======================================================================

                      Text(
                        "$number.",
                        style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onInverseSurface,
                            fontWeight: FontWeight.w600
                        ),
                      ),

                      const SizedBox(height: 8),

                      //=======================================================================
                      // SOURCE/DATE
                      //=======================================================================

                      Row(
                        children: () {
                          final dateStr = getDateTextForResult(memory);
                          var sourceStr = getSourceForResult(memory).toUpperCase();
                          if (sourceStr.isEmpty) sourceStr = '(unknown)';   // @TODO: Handle missing source text better

                          final textStyle = theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.onInverseSurface);
                          final textStyleBold = textStyle.copyWith(fontWeight: FontWeight.w600);

                          var widgets = [
                            Text(sourceStr, style: textStyleBold),
                            if (dateStr != null) Text(' / ', style: textStyleBold),
                            if (dateStr != null) Text(dateStr, style: textStyle),
                          ];

                          return widgets;
                        }(),
                      ),

                      const SizedBox(height: 12),

                      //=======================================================================
                      // TITLE AND PRICE INFO
                      //=======================================================================

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: Text(
                              getTitleTextForResult(memory) ?? '',
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onInverseSurface,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 0),
                            child: PriceInfoMini(memory: memory, isOnInverseSurface: true,),
                          ),
                        ],
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
