// lib/widgets/force_graph/node_details_overlay.dart
import 'package:flutter/material.dart';

class NodeDetailsOverlay extends StatelessWidget {
  final Map<String, dynamic> node;

  const NodeDetailsOverlay({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            node['title'] ?? "",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 2),
          _InfoRow('Source:', node['source']),
          _InfoRow('Channel:', node['channel']),
          _InfoRow('Date:', node['date']),
          _InfoRow('Type:', node['type']),
          _InfoRow('Value:', node['value'].toString()),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            value!,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w100,

            ),
          ),
        ],
      ),
    );
  }
}