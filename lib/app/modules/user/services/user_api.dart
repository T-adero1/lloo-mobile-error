import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import '../models/wallet_transaction.dart';
import '../models/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:lloo_mobile/app/core/services/firebase_setup.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/lloo_exceptions.dart';

class UserApi extends GetxService {
  // final FirebaseAuth _auth = Get.find();
  final FirebaseFirestore _userDb = Get.find();

  Future<UserDetails?> fetchDetails(String userId) async {
    try {
      L.info("USER_API", "Fetching user details for user $userId");
      final doc = await _userDb.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        // Create our object adding the userId
        return UserDetails.fromJson(doc.data()!..['userId'] = userId);
      }
      L.warn("UserAPI", "User details not found for user id $userId");
      return null;
    } on FirebaseException catch (e) {
      throw LlooApiException('Failed to fetch user details', underlyingError: e);
    }
  }

  Future<UserDetails?> fetchDetailsForUserEmail(String userEmail) async {
    try {
      L.info("USER_API", "Fetching user details for user $userEmail");
      // @TODO: Handle accidental repeats? Fetch latest??
      final query = await _userDb.collection('users').where('email', isEqualTo: userEmail).limit(1).get();
      if (query.docs.isEmpty) {
        L.debug("USER_API", "...none found");
        return null;
      }
      final doc = query.docs.first;
      if (doc.exists) {
        // Create our object adding the userId
        return UserDetails.fromJson(doc.data()..['userId'] = doc.id);
      }
      L.debug("UserAPI", "User details not found for user email $userEmail");
      return null;
    } on FirebaseException catch (e) {
      throw LlooApiException('Failed to fetch user details', underlyingError: e);
    }
  }

  Future<UserDetails> registerUser({required String email}) async {
    try {
      L.info("USER_API", "Creating new user in db with email: $email");
      final doc = await _userDb.collection('users').add({'email': email});
      L.info("USER_API", "...successfully registered user. User ID = ${doc.id}");
      return UserDetails.fromJson({'userId': doc.id, 'email': email});
    } on FirebaseException catch (e) {
      throw LlooApiException('Failed to register user', underlyingError: e);
    }
  }

  Future<void> updateUserDetails(UserDetails userDetails) async {
    try {
      L.info("USER_API", "Updating user details for user ${userDetails.userId}");
      await _userDb
          .collection('users')
          .doc(userDetails.userId)
          .update(userDetails.toJson());
      L.info("USER_API", "...successfully updated user details.");
    } on FirebaseException catch (e) {
      throw LlooApiException('Failed to update user details', underlyingError: e);
    }
  }

  Future<Map<String, dynamic>?> fetchHoldings(userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return {
      'attnHoldings': 2000.0,
      'stakedMemories': [
        Memory.fromJson({'id': 'ATTN', 'title': 'ATTN Memory', 'description': 'dfgsfg Memory', 'calculated_price': '5500', 'target_price': '800', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-234234sfsdef', 'title': 'Memory 234', 'description': 'sdggdfag Memory', 'calculated_price': '2000', 'target_price': '400', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-244234sfsdef', 'title': 'Memory 244', 'description': 'asfg Memory', 'calculated_price': '1500', 'target_price': '300', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-254234sfsdef', 'title': 'Memory 254', 'description': 'adfgfg Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-264234sfsdef', 'title': 'Memory 264', 'description': 'vdafv Memory', 'calculated_price': '2000', 'target_price': '400', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-274234sfsdef', 'title': 'Memory 274', 'description': 'afsgfg Memory', 'calculated_price': '1500', 'target_price': '300', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-284234sfsdef', 'title': 'Memory 284', 'description': 'fsg Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-294234sfsdef', 'title': 'Memory 294', 'description': 'g3 Memory', 'calculated_price': '2000', 'target_price': '400', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-204234sfsdef', 'title': 'Memory 204', 'description': 'fgdfg Memory', 'calculated_price': '1500', 'target_price': '300', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-214234sfsdef', 'title': 'Memory 214', 'description': 'fdgsfg Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-214236sfsdef', 'title': 'Memory 214-2', 'description': 'fgh Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-214237sfsdef', 'title': 'Memory 214-3', 'description': 'hjfd Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
      ],
      'linkedMemories': [
        MemoryLink(memory0Id: "mem_01a2b3", memory0TokenName: "mem_01a2b3", memory0TokenReserve: 9131, memory1Id: "mem_98y7x6", memory1TokenName: "mem_98y7x6", memory1TokenReserve: 654.234, totalLockedValue: 1324.34567),
        MemoryLink(memory0Id: "mem_45c6d7", memory0TokenName: "mem_45c6d7", memory0TokenReserve: 4211, memory1Id: "mem_23k4j5", memory1TokenName: "mem_23k4j5", memory1TokenReserve: 2345.1355, totalLockedValue: 4231.76433),
        MemoryLink(memory0Id: "mem_89e0f1", memory0TokenName: "mem_89e0f1", memory0TokenReserve: 6933, memory1Id: "mem_34h5g6", memory1TokenName: "mem_34h5g6", memory1TokenReserve: 978.2356, totalLockedValue: 3456.23456),
        MemoryLink(memory0Id: "mem_12g3h4", memory0TokenName: "mem_12g3h4", memory0TokenReserve: 1957, memory1Id: "mem_78n9m0", memory1TokenName: "mem_78n9m0", memory1TokenReserve: 156.245645, totalLockedValue: 1324.4254),
        MemoryLink(memory0Id: "mem_56i7j8", memory0TokenName: "mem_56i7j8", memory0TokenReserve: 8133, memory1Id: "mem_12p3q4", memory1TokenName: "mem_12p3q4", memory1TokenReserve: 9877.34565, totalLockedValue: 846.334),
      ],
      'createdMemories': [
        Memory.fromJson({'id': 'M-244234sfsdef', 'title': 'Memory 244', 'description': 'asfg Memory', 'calculated_price': '1500', 'target_price': '300', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-254234sfsdef', 'title': 'Memory 254', 'description': 'adfgfg Memory', 'calculated_price': '500', 'target_price': '199', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'}),
        Memory.fromJson({'id': 'M-264234sfsdef', 'title': 'Memory 264', 'description': 'vdafv Memory', 'calculated_price': '2000', 'target_price': '400', 'group': 'doc', 'timestamp': DateTime.now().toIso8601String(), 'source': 'token', 'imageUrl': 'https://picsum.photos/200'})
      ]
    };
  }

  Future<List<WalletTransaction>?> fetchTransactionHistory(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      AttnMarketTransaction(attnAmount: 1000.12345, fiatAmount: -500.98765),
      AttnTransferTransaction(myWalletId: 'wallet_alice', theirWalletId: 'wallet_bob', attnAmount: 250.45678),
      MemoryStakeTransaction(memoryId: 'mem_001', memoryLabel: 'First Day at College', attnAmount: -100.23456),
      LinkStakeTransaction(memoryAId: 'mem_001', memoryBId: 'mem_002', memoryALabel: 'First Day at College', memoryBLabel: 'Graduation Day', attnAmount: 75.34567),
      AttnMarketTransaction(attnAmount: -500.87654, fiatAmount: 275.12345),
      MemoryStakeTransaction(memoryId: 'mem_003', memoryLabel: 'Summer Vacation 2024', attnAmount: 150.65432),
      AttnTransferTransaction(myWalletId: 'wallet_alice', theirWalletId: 'wallet_charlie', attnAmount: -300.78901),
      LinkStakeTransaction(memoryAId: 'mem_003', memoryBId: 'mem_004', memoryALabel: 'Summer Vacation 2024', memoryBLabel: 'New Year Party', attnAmount: 125.45678),
      AttnMarketTransaction(attnAmount: 2000.98765, fiatAmount: -1000.23456),
    ];
  }
}