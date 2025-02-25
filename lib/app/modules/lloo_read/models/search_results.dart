import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'search_stage.dart';


/// Model for all the data for search results including Entries, Links and
/// related data. Sent at each stage of the Cue2Lit process though not all
/// fields will contain data at all points
@immutable
class SearchResultsData {
  final SearchStage stage;
  final List<Memory> memories;
  // These will be [] until the stage they are specified in the results
  final List<MemoryLink> links;
  final String? llmSummary;
  final List<String> memoryIdsUsed;

  List<Memory>? get documentTypeMemories {
    final mems = memories.where((m) => m.type == MemoryType.doc).toList();
    return mems;
  }

  List<Memory>? get memoriesUsed {
    if (memoryIdsUsed.isEmpty) return null;
    final used = memoryIdsUsed.map((id) {
      try {
        return memories.firstWhere((m) => m.id == id);
      } catch (e) {
        L.warn("SEARCH",
            "?? Could not find used memory in memories list. id: $id");
        return null;
      }
    }).where((e) => e != null)
        .map((e) => e!)
        .toList();  // remove the nulls

    return used;
  }

  // constructors
  const SearchResultsData({
    required this.stage,
    required this.memories,
    required this.links,
    required this.llmSummary,
    required this.memoryIdsUsed,
  });

  factory SearchResultsData.fromJson(Map<String, dynamic> json) =>
      SearchResultsData(
        stage: SearchStage.fromStatus(json['status']),
        llmSummary: _cleanLLMSummary(json['llm_summary']),
        memories: (json['results'] ?? []).map<Memory>((m) => Memory.fromJson(m)).toList(),
        links: (json['links'] ?? []).map<MemoryLink>((l) => MemoryLink.fromJson(l)).toList(),
        memoryIdsUsed: List<String>.from(json['used_memory_ids'] ?? []),
      );
}



//=======================================================================
// CLEANUP, NORM & POLYFILL FUNCTIONS
//=======================================================================

/// clean up the literal response from the server which includes some metadata
String _cleanLLMSummary(String? llmSummary) {
  String cleaned = llmSummary ?? '';

  // Strip the prefix "Summary: " if it exists
  if (cleaned.startsWith('Summary:')) {
    cleaned = cleaned.substring(9);
  }

  // Look for "Memories used:" in the body and remove all text after
  final i = cleaned.indexOf('Memories used:');
  if (i > -1) {
    cleaned = cleaned.substring(0,i);
  }

  return cleaned.trim();
}


// String _polyfillLinks(List<Memories> memories) {



