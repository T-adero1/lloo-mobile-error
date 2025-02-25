

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;


class MemoriesService {

  final FirebaseFirestore _firestore = Get.find();


  MemoriesService();

  Future<Memory?> fetchMemoryById(String memoryId) async {
    // use firebase to fetch from the memories collection with the given id
    try {
      L.info("MEM_SERVICE", "Fetching memory with id $memoryId..., ");
      final doc = await _firestore
          .collection('memory')
          .doc(memoryId)
          .get();

      if (!doc.exists) {
        L.warn("MEM_SERVICE", "Memory with id $memoryId does not exist");
        return null;
      }

      // Parse into a memory object
      final json = { ...?doc.data(), 'id': memoryId };
      final memory = Memory.fromJson(json);
      return memory;

    } catch (e) {
      L.error('MEM_SERVICE', 'Error getting memory: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------

  // @TODO: Do it fo'realz
  Future<List<Memory>> fetchRelatedMemories(Memory memory) async {
    // Replace this with your actual service call to fetch related memories
    // based on the memory and type
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      Memory.fromJson({'id': 'M-204234sfsdef', 'title': 'Memory 204', 'description': 'fgdfg Memory', 'calculated_price': '1500', 'target_price': '300', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
      Memory.fromJson({'id': 'M-214234sfsdef', 'title': 'Memory 214', 'description': 'fdgsfg Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
      Memory.fromJson({'id': 'M-214236sfsdef', 'title': 'Memory 214-2', 'description': 'fgh Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
    ];
  }

}