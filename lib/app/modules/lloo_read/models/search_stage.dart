import 'package:get/get.dart';

enum SearchStage {
  cue,
  associate,
  research,
  enrich,
  augment,
  equalize,
  produce,
  lit;

  SearchStage nextStage() {
    final values = SearchStage.values;
    final index = this.index;

    if (index >= values.length - 1) {
      throw StateError('No next stage available after ${this.name}');
    }

    return values[index + 1];
  }

  bool isLastStage() {
    return index == SearchStage.values.length - 1;
  }

  // Create from the status string from Firestore
  factory SearchStage.fromStatus(String status) {
    switch (status) {
      case 'expanding_search_types':
        return SearchStage.cue;
      case 'got_vectors':
        return SearchStage.associate;
      case 'search_types_determined':
        return SearchStage.research;
      case 'metadata_combined':
        return SearchStage.enrich;
      case 'results_saved':
        return SearchStage.augment;
      case 'equalizing':
        return SearchStage.equalize;
      case 'llm_summary_generated':
        return SearchStage.produce;
      case 'completed':
        return SearchStage.lit;
      default:
        return SearchStage.cue;
    }
  }

  String get name {
    // return toString();
    switch (this) {
      case SearchStage.cue:
        return 'Cue';
      case SearchStage.associate:
        return 'Associate';
      case SearchStage.research:
        return 'Research';
      case SearchStage.enrich:
        return 'Enrich';
      case SearchStage.augment:
        return 'Augment';
      case SearchStage.equalize:
        return 'Equalize';
      case SearchStage.produce:
        return 'Produce';
      case SearchStage.lit:
        return 'Lit';
    }
  }
}
