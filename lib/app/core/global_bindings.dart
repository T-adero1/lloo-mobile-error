import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lloo_mobile/app/core/services/lloo_api.dart';
import 'package:lloo_mobile/app/core/services/media_storage_service.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:get/get.dart';
import 'package:magic_sdk/magic_sdk.dart';

import 'services/firebase_setup.dart';

/// Bindings used by multiple modules.
/// We'll instantiate manually in main.dart
class GlobalBindings {
  Future<void> initDependencies() async {
    L.info("BINDINGS", "Init'ing global dependencies...");
    
    // Initialize GetStorage for persistence
    await GetStorage.init();
    L.info("BINDINGS", "GetStorage initialized");

    Magic.instance = Magic("pk_live_7164BAE04E8A3470");//Magic("pk_live_4EE0969819286C2E");
    Get.put(Magic.instance, permanent: true);

    // Initialize Firebase dependencies
    await initFirestoreDependencies();
    
    // Initialize MediaStorageService
    Get.put(Dio(), permanent: true);
    Get.put(MediaStorageService(), permanent: true);
    
    L.info("BINDINGS", "MediaStorageService initialized");
  }
}