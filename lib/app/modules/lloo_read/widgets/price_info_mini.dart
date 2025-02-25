
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/core/utils/formatting.dart';

import 'price_graph_mini.dart';
class PriceInfoMini extends StatelessWidget {
  const PriceInfoMini({
    super.key,
    required this.memory,
    this.isOnInverseSurface = false,
  });

  final Memory memory;
  final bool isOnInverseSurface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceColor = isOnInverseSurface ? theme.colorScheme.onInverseSurface : theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        // ======================================================================
        // PERC & NUMBER
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('+${Random().nextInt(101) + 11}%',
                // This could be calculated from result.value if needed
                style: theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.tertiary),
              ),

              const SizedBox(height: 2),  //@TODO: figure out how to get this bottom aligned with graph

              Text(
                  formattedAttnPrice(memory.calculatedPrice),
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, color: priceColor)
              ),
            ],
          ),

        SizedBox(width: 4.0),
        // ======================================================================
        // GRAPH & "ATTN"
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              width: 40,
              height: 12,
              child: PriceGraphMini(),
            ),

            const SizedBox(width: 4),
            Text(
                'ATTN',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, color: priceColor)
            ),

          ],
        ),
      ],
    );
  }
}