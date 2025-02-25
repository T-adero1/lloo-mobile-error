
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;


// ======================================================================
// MEMORY
// ======================================================================

enum MemoryType { source, category, doc }

/// Wrap the json in order to do some name translating (with an eye towards not needing to future)
///
/// Ok the plan here
/// - Make a flexible (lots of optionals) class to just model the existing json
///   and have the basics to translate to the view
/// - Later I imagine the view cards, and details view might be dependent on the type
///   and channel so we might use a base class and factory
class Memory {
  final Map<String, dynamic> json;

  /// Convert the type from current "group" field
  /// Default to "doc" as many of those lack a group field
  /// @TODO clean this up once data schema and db is cleaned up
  MemoryType get type {
    return {
      "source": MemoryType.source,
      "category": MemoryType.category,
      "doc": MemoryType.doc
    }[json['group']] ?? MemoryType.doc;
  }

  // Stub for the title getter
  String get id => json['id'];
  String? get title => json['title'];
  String? get description => json['description'];
  String? get source => json['source'];
  String? get imageUrl => json['imageUrl'];
  double get calculatedPrice => parseToDouble(json['calculated_price']) ?? 0.0;
  double get targetPrice => parseToDouble(json['target_price']) ?? 0.0;

  /// Make a proper DateTime from the timestamp. Normalise the formats.
  /// @TODO make all the converions handled by a utility class/func, and move funcs at bottom there too
  DateTime? get timestamp {
    // Format can either be ISO or a unix timestamp json {'_seconds': 0, '_nanoseconds': 0}
    final ts = json['timestamp'];
    if (ts == null) return null;
    try {
      final dateTime = DateTime.parse(ts);
      return dateTime;
    } catch (e) {
      // Try the other format
      try {
        final ts2 = ts.replaceAll("'", '"');
        final Map<String, dynamic> parsedTs = jsonDecode(ts2);
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
            parsedTs['_seconds'] * 1000 + (parsedTs['_nanoseconds'] ~/ 1000000)
        );
        return dateTime;
      } catch (e) {
        // Another type: 8/8/2024, 4:22:36 AM
        try {
          final dateTime = DateFormat("M/d/yyyy, h:mm:ss a").parse(ts.trim());
          return dateTime;
        } catch (e) {
          L.error("SEARCH", "Error parsing timestamp $ts, error: $e}",);
          return null;
        }

      }
    }
  }

  // constructor
  Memory(this.json) {
    // if (json['title']?.startsWith('CNN') ?? false) {
    //   L.debug("SEARCH", "title: ${json['title']}, type: ${json['group']}");
    // }
  }
  Memory.fromJson(this.json);
}


// ======================================================================
// MEMORY LINK
// ======================================================================

@immutable
class MemoryLink {
  final String memory0Id;
  final String memory0TokenName;
  final double memory0TokenReserve;
  final String memory1Id;
  final String memory1TokenName;
  final double memory1TokenReserve;

  final double totalLockedValue;

  const MemoryLink({
    required this.memory0Id,
    required this.memory0TokenName,
    required this.memory0TokenReserve,
    required this.memory1Id,
    required this.memory1TokenName,
    required this.memory1TokenReserve,
    required this.totalLockedValue
  });

  factory MemoryLink.fromJson(Map<String, dynamic> json) => MemoryLink(
    memory0Id: json['token0'],
    memory0TokenName: json['token0_name'] ?? '',
    memory0TokenReserve: json['token0_reserve'],
    memory1Id: json['token1'],
    memory1TokenName: json['token1_name'] ?? '',
    memory1TokenReserve: json['token1_reserve'],
    totalLockedValue: json['total_locked_value'],
  );

  factory MemoryLink.fromMemories(Memory memory0, Memory memory1, double value)
  => MemoryLink(
    memory0Id: memory0.id,
    memory0TokenName: memory0.title ?? "-",
    memory0TokenReserve: memory0.calculatedPrice,
    memory1Id: memory1.id,
    memory1TokenName: memory1.title ?? "-",
    memory1TokenReserve: memory1.calculatedPrice,
    totalLockedValue: value
  );

}



// ======================================================================
// HELPER FUNCTION
// ======================================================================
// @TODO: Move these to util file

double? parseToDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Helpful functions for normalising values to view
String getTitleTextForResult(Memory result) {
  // Title if we have it
  if (result.title != null && result.title!.isNotEmpty) {
    return result.title!;
  }
  // Otherwise description truncated
  if (result.description != null) {
    return result.description!;
  }
  // Otherwise name
  return result.json['name'] ?? 'Untitled';
}
String? getDateTextForResult(Memory result) {
  if (null == result.timestamp) return null;
  return DateFormat('yyyy.MM.dd').format(result.timestamp!);
}

String getSourceForResult(Memory result) {
  var source = result.source ?? 'LLOO';  // Future Mems dont have sources usually
  return source;
}