

import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';

class MemoryDetailsViewModel {


  final Rx<Memory>memory;

  final linkedMemoriesByUser = Rx<List<Memory>?>(null);
  final linkedMemoriesByTopic = Rx<List<Memory>?>(null);
  final linkedMemoriesByRelated = Rx<List<Memory>?>(null);

  // temp types until we model
  final Map<String, dynamic>? memoriesStackingInfoData = null;
  final Map<String, dynamic>? memoriesStackingGraphData = null;
  final Map<String, dynamic>? userStakingInfoData = null;


  MemoryDetailsViewModel({required Memory memory}) : memory = Rx<Memory>(memory);
}