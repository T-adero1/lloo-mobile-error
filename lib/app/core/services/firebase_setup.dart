import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/firebase_options.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

// @TODO: #low-p define the apps here and move the type inits to their respective modules??
/// Register the various Firebase actors across different projects Call this in main before launch
Future<void> initFirestoreDependencies() async {
  // final FirebaseApp secondaryApp = Firebase.app('SecondaryApp');

  // FIRESTORE: Comes from fm-dev-v1 project
  // For now this will be the user database as well
  // Auth will come later
  final appFmDev = await Firebase.initializeApp(
    name: 'FirestoreIO',
    options: DefaultFirebaseOptions.firestoreFmDevOptions,
  );
  final instanceFmDev = FirebaseFirestore.instanceFor(app: appFmDev);
  instanceFmDev.settings = const Settings(persistenceEnabled: true);
  Get.put(instanceFmDev, permanent: true);

  // Initialize Firebase Storage
  final storage = FirebaseStorage.instanceFor(app: appFmDev);
  Get.put(storage, permanent: true);

  L.info("GLOBAL", "Firebase Storage initialized");

  // // FIREBASE: lloo (new) user and other data for LLOO app
  // final appLloo = await Firebase.initializeApp(
  //   name: 'FirestoreIO',
  //   options: DefaultFirebaseOptions.firestoreLlooOptions,
  // );
  // final instanceLloo = FirebaseFirestore.instanceFor(app: appLloo);
  // instanceLloo.settings = const Settings(persistenceEnabled: true);
  // Get.put(instanceLloo, permanent: true, tag: FirestoreProject.lloo.name);
  //
  // L.info("GLOBAL", "Firestore init'ed with offline persistence");

  // ---------------------------------------------------------------------
  // FIREBASE AUTH AND USER
  //
  // Not using real auth for now
  // // Lloo app for our users
  // Get.put(FirebaseAuth.instanceFor(app: appLloo), permanent: true);
}
