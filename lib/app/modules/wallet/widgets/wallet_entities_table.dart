
// ======================================================================
// TABLE
// ======================================================================

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/core/widgets/app_icon.dart';

/// Generic table for the various user wallet views
class WalletEntitiesTable<T> extends StatelessWidget {
  final List<T> entities;
  final WalletEntitiesTableRow Function(BuildContext context, T entity, int index) rowBuilder;

  const WalletEntitiesTable({
    super.key,
    required this.entities,
    required this.rowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entities.length,
      separatorBuilder: (context, index) => const Divider(indent: 0, endIndent: 0),
      itemBuilder: (context, index) => Column(
        children: [
          rowBuilder(context, entities[index], index),
        ],
      ),
    );
  }
}

// ======================================================================
// ROW
// ======================================================================


class WalletEntitiesTableRow extends StatelessWidget {
  const WalletEntitiesTableRow({
    super.key,
    this.thumbnailUrl,
    this.iconName,
    required this.titleLabel,
    this.subtitleLabel,
    this.secondaryLabel,
    required this.valueLine1,
    this.valueLine2,

  });


  final String? thumbnailUrl;
  final String? iconName;
  final String titleLabel;
  final String? subtitleLabel;
  final String? secondaryLabel;
  final String valueLine1;
  final String? valueLine2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [

        // ======================================================================
        // THUMB / ICON
        // ======================================================================

        if (thumbnailUrl != null) ...[
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(imageUrl: thumbnailUrl!)
          ),
        ],

        if (iconName != null) ...[
          const SizedBox(width: 4),
          ClipRect(
            child: SizedBox(
              width: 20,
              child: Center(
                child:
          AppIcon(iconName!, size: 20),
              ),
            ),
          ),
        ],

        const SizedBox(width: 12),

        // ======================================================================
        // LABELS
        // ======================================================================

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MAIN TITLE LABEL
              Text(
                titleLabel,
                style: theme.textTheme.labelMedium,
              ),

              // SUBTITLE OR SECONDARY LABEL
              // Secondary label is styled same as title but subtitle has less emphasis
              if (subtitleLabel != null || secondaryLabel != null)
                Text(
                    subtitleLabel ?? secondaryLabel ?? '', // just for linter
                    style: subtitleLabel != null
                        ? theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.secondary)
                        : theme.textTheme.labelMedium
                ),
            ],
          ),
        ),

        // ======================================================================
        // VALUES
        // ======================================================================

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              valueLine1,
              style: theme.textTheme.labelMedium,
            ),
            if (valueLine2 != null)
              Text(
                valueLine2!,
                style: theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.secondary),
              ),
          ],
        ),
      ],
    );
  }
}