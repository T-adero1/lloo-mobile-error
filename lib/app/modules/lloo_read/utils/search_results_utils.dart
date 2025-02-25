
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/modules/lloo_read/models/search_results.dart';

import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;



// We want to flush out the graph as quickly as possible however links only
// comes in at the third stage. Thus we'll insure that LLOO Node note is available
// (creating it if not) and links exist between it and all sources and categories

/// Polyfill links and memories if links is empty
SearchResultsData polyfillSearchResults(SearchResultsData searchResults) {
  if (searchResults.links.isNotEmpty) return searchResults;

  // Check to see if a Memory with title LLOO exists. Otherwise create
  // a new Memory list and add it
  Memory llooNode;
  var newMemories = List<Memory>.from(searchResults.memories);
  List<MemoryLink> newLinks = [];

  try {
    llooNode = searchResults.memories.firstWhere((m) => m.title == 'LLOO');
  } on StateError catch (_, e) {
    llooNode = Memory({
      'id': 'tmp-lloo-node',
      'title': 'LLOO',
      'group': 'source',
      'calculated_price': 1.0,
      'target_price': 1.0,
      'description': 'LLOO sourced content'
    });
    newMemories.add(llooNode);
  }

  // Now create links from all other entities to this one
  newLinks = newMemories.map((mem) {
    if (mem.id == llooNode.id) return null;
    return MemoryLink.fromMemories(llooNode, mem, 1.0);
  }).where((link) => link != null).cast<MemoryLink>().toList();

  final didAddLloo = newMemories.length > searchResults.memories.length;
  L.info("SEARCH", "Polyfilled search results with ${newLinks.length} links. DID ${didAddLloo ? '' : 'NOT'} add LLOO node.");

  return SearchResultsData(
    stage: searchResults.stage,
    llmSummary: searchResults.llmSummary,
    memories: newMemories,
    links: newLinks,
    memoryIdsUsed: searchResults.memoryIdsUsed,
  );
}