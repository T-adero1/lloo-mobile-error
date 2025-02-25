// File: lib/services/search_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lloo_mobile/app/modules/lloo_read/utils/search_results_utils.dart';

import '../models/search_results.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;



/// Service responsible for handling Cue2Lit search queries.
class SearchService {
  final FirebaseFirestore _firestore = Get.find();
  final http.Client _httpClient;
  StreamController<SearchResultsData>? controller;
  StreamSubscription<DocumentSnapshot>? subscription;

  SearchService()  : _httpClient = http.Client();

  /// Initiates a search query with the given [searchString].
  ///
  /// Returns a [Stream] of [Cue2LitSearchResult] that emits updates as the search progresses.
  /// The stream can be cancelled by unsubscribing, which will also cancel the Firestore listener.
  Future<Stream<SearchResultsData>> query(String searchString) async {
    L.info('SEARCH', "Initiating search with query: '$searchString'");

    controller = StreamController<SearchResultsData>();

    try {
      // Generate a new Firestore document reference with a unique ID.
      final DocumentReference searchDocRef =
      _firestore.collection('searches').doc();
      final String docId = searchDocRef.id;

      // Set some vals to create the doc
      searchDocRef.set({
        'status': 'expanding_search_types', // @TODO move all status dependencies into Cue2LitStage enum
        'created_at': FieldValue.serverTimestamp(),
      }).then( (_) => L.debug('SEARCH', "Document created with id $docId") );

      // Send the search query to the backend.
      // No need to wait for this to assign listener
      _sendQueryToBackend(searchString, docId).then((_) {});

      // Listen to real-time updates on the Firestore document.
      subscription = searchDocRef.snapshots().listen(
            (snapshot) {
          if (snapshot.exists) {
            // L.verbose("SEARCH", "Received snapshot for docId: ${snapshot.id}");

            // Create the Results object from the json
            Map<String, dynamic> data = snapshot.data() as Map<String,
                dynamic> ?? {};

            // a little debug hook
            // if (data['status'] == 'completed') {
            //   L.debug("SEARCH", "...");
            // }

            // Wrap this and rethrow as the constructor hides exceptions in its initialiser params (ugh!)
            try {
              final resultsData = polyfillSearchResults(SearchResultsData.fromJson(data));
              if (controller == null) {
                L.warn("SEARCH", "Stream Controller is null!");
              }
              controller?.add(resultsData);
            } catch (e, stacktrace) {
              L.error("SEARCH", "Error parsing results data: $e", stacktrace);
              throw e;
            }
          } else {
            controller?.addError('Document does not exist.');
          }
        },
        onError: (error) {
          controller?.addError(error);
        },
      );

      // Handle stream cancellation by cancelling the Firestore subscription.
      controller?.onCancel = () {
        subscription?.cancel();
      };
    } catch(error) {
        // If sending the query fails, emit the error and close the stream.
        controller?.addError(error);
        controller?.close();
    }

    return controller!.stream;
  }

  cancel() {
    subscription?.cancel();
    controller?.close();
  }

  /// Sends the search [query] and [docId] to the backend.
  ///
  /// Currently, [augmentations] is an empty object as per the requirements.
  Future<void> _sendQueryToBackend(String query, String docId) async {
    // @TODO: Can we .env this?
    final Uri url = Uri.parse('https://fm-dev-v1.uc.r.appspot.com/cue');

    final Map<String, dynamic> payload = {
      'query': query,
      'augmentations': {}, // Empty object as user ID is not available yet.
      'search_doc_id': docId,
    };

    try {
      final http.Response response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to send query. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send query to backend: $e');
    }
  }
}