import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/modules/user/models/user_details.dart';
import 'package:lloo_mobile/app/modules/user/models/wallet_transaction.dart';

import 'firebase_setup.dart';

// class LlooApi {
//   final FirebaseFirestore _firestore = Get.find<FirebaseFirestore>(tag: FirestoreProjectScope.datastore.name);
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // User related methods
//   Future<UserDetails?> getUserDetails(String userId) async {
//     try {
//       final doc = await _firestore.collection('users').doc(userId).get();
//       if (!doc.exists) return null;
//       return UserDetails.fromJson(doc.data()!..['userId'] = userId);
//     } catch (e) {
//       print('Error getting user details: $e');
//       return null;
//     }
//   }
//
//
//   Future<List<Memory>> getUserMemories(String userId) async {
//     try {
//       final snapshot = await _firestore
//           .collection('memories')
//           .where('createdBy', isEqualTo: userId)
//           .get();
//       return snapshot.docs.map((doc) => Memory.fromJson(doc.data())).toList();
//     } catch (e) {
//       print('Error getting user memories: $e');
//       return [];
//     }
//   }
//
//   Future<double?> getUserAttnHoldings(String userId) async {
//     try {
//       final doc = await _firestore.collection('wallets').doc(userId).get();
//       if (!doc.exists) return null;
//       return doc.data()?['attnBalance']?.toDouble();
//     } catch (e) {
//       print('Error getting ATTN holdings: $e');
//       return null;
//     }
//   }
//
//   Future<List<WalletTransaction>> getUserTransactions(String userId) async {
//     try {
//       final snapshot = await _firestore
//           .collection('transactions')
//           .where('userId', isEqualTo: userId)
//           .orderBy('timestamp', descending: true)
//           .get();
//       return snapshot.docs
//           .map((doc) => WalletTransaction.fromJson(doc.data()))
//           .toList();
//     } catch (e) {
//       print('Error getting transactions: $e');
//       return [];
//     }
//   }
// }
