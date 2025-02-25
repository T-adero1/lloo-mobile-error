
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/modules/lloo_read/lloo_read_styles.dart';
import 'package:lloo_mobile/app/modules/lloo_read/widgets/price_graph_mini.dart';
import 'package:lloo_mobile/app/app_theme.dart';

import '../../../app_styles.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import '../models/search_results.dart';
import 'price_info_mini.dart';

class StandardResultsList extends StatelessWidget {
  final List<Memory> memories;
  final Function(Memory memory)? onMemoryTapped;

  const StandardResultsList({
    super.key,
    required this.memories,
    this.onMemoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    const double kResultCardDividerThickness = 0.75;
    const double kResultCardDividerHeight = 10;
    const double kResultCardIndexNumberWidth = 20;    // ensure these match the ones in the SRCard below
    const double kResultCardHorizontalPadding = 14;


    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: kScreenPaddingSizeLR,
      ),
      itemCount: memories.length,
      itemBuilder: (context, index) {
        final memory = memories[index];
        return Column(
          children: [
            InkWell(
              onTap: () => onMemoryTapped?.call(memory),
              child: StandardResultCard(index: index, total: memories.length, memory: memory),
            ),

            // Line separator
            if (index < memories.length - 1) const Divider(
              height: kResultCardDividerHeight,
              thickness: kResultCardDividerThickness,
              indent: kResultCardIndexNumberWidth + kResultCardHorizontalPadding,
              endIndent: 0,
            ),
          ],
        );
      },
    );
  }
}

//=======================================================================
// RESULT CARD
//=======================================================================


/// Standard result card for the cue2lit process
class StandardResultCard extends StatelessWidget {
  const StandardResultCard({
    super.key,
    required this.index,
    required this.total,
    required this.memory,
  });

  final Memory memory;
  final int total;
  final int index;

  @override
  Widget build(BuildContext context) {
    
    //=======================================================================
    // STYLES
    //=======================================================================
    final theme = Theme.of(context);
    const double kResultCardHeight = 160;
    const double kResultCardImageWidth = 120;
    const double kResultCardIndexNumberWidth = 20; // Make sure these match the ones above
    const double kResultCardHorizontalPadding = 14;
    const double kResultCardTitleTextVerticalPadding = 18;
    const Color kResultCardIndexNumberHotColor = Colors.red;
    const Color kResultCardIndexNumberColdColor = Colors.blue;
    final kResultCardAskPriceFont = theme.textTheme.bodyLarge!.copyWith(color: Colors.blue, fontWeight: FontWeight.w600,);
    
    //=======================================================================
    // WIDGET
    //=======================================================================
    
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: kResultCardHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //=======================================================================
            // INDEX NUMBER
            // - Gradient from red to blue ("hot" to "cold" results)
            //=======================================================================
            Container(
              margin: EdgeInsets.only(top: 3),
              width: kResultCardIndexNumberWidth,
              child: Text(
                (index + 1).toString().padLeft(2, '0'),
                style: theme.textTheme.labelLarge!.copyWith(
                    color: Color.lerp(
                        kResultCardIndexNumberHotColor,
                        kResultCardIndexNumberColdColor,
                        sqrt(index.toDouble() / (total-1).toDouble()) // sqrt to make it blue faster
                    )
                ),
              ),
            ),

            SizedBox(width: kResultCardHorizontalPadding),

            //======================================================================
            // THUMBNAIL
            // - Make it cover a fixed size
            //======================================================================
            SizedBox(
              width: kResultCardImageWidth,
              height: kResultCardHeight, // Add fixed height
              child: ClipRect(
                child: CachedNetworkImage(
                  imageUrl: memory.imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),

            SizedBox(width: kResultCardHorizontalPadding),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 8.0),

                  //======================================================================
                  // SOURCE & DATE
                  //======================================================================
                  Row(
                    children: () {
                      final dateStr = getDateTextForResult(memory);
                      var sourceStr = getSourceForResult(memory).toUpperCase();
                      if (sourceStr.isEmpty) sourceStr = '(unknown)';   // @TODO: Handle missing source text better

                      final textStyle = theme.textTheme.labelSmall!;
                      final textStyleBold = textStyle.copyWith(fontWeight: FontWeight.w600);

                      var widgets = [
                        Text(sourceStr, style: textStyleBold),
                        if (dateStr != null) Text(' / ', style: textStyleBold),
                        if (dateStr != null) Text(dateStr, style: textStyle),
                      ];

                      return widgets;
                    }(),
                  ),

                  SizedBox(height: kResultCardTitleTextVerticalPadding),

                  // ======================================================================
                  // TITLE
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      getTitleTextForResult(memory) ?? '',
                      style: theme.textTheme.bodyMedium!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: kResultCardTitleTextVerticalPadding),


                  // ======================================================================
                  // VALUE
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: PriceInfoMini(memory: memory),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
