import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/lloo_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

enum MediaType {
  original,
  aiPhoto,
  aiVideo
}

class MediaStorageService {
  FirebaseStorage get _storage => Get.find<FirebaseStorage>();
  final _dio = Get.find<Dio>();

  Future<String> saveUserAvatar({
    required String userId,
    required File image,
  }) async {
    L.info('MEDIA_STORAGE', 'Saving user avatar for user: $userId');
    
    final ext = path.extension(image.path);
    final ref = _storage.ref().child('avatars/$userId$ext');
    
    try {
      L.debug('MEDIA_STORAGE', 'Starting upload to path: avatars/$userId$ext');
      
      final uploadTask = await ref.putFile(
        image,
        SettableMetadata(
          contentType: 'image/${ext.substring(1)}',
          customMetadata: {'userId': userId},
        ),
      );
      
      if (uploadTask.state == TaskState.success) {
        final downloadUrl = await ref.getDownloadURL();
        L.info('MEDIA_STORAGE', 'Avatar upload successful, URL: $downloadUrl');
        return downloadUrl;
      }
      
      L.error('MEDIA_STORAGE', 'Upload failed with state: ${uploadTask.state}');
      throw LlooMediaStorageException('Failed to upload avatar: Task state ${uploadTask.state}');
    } catch (e) {
      L.error('MEDIA_STORAGE', 'Error uploading avatar: $e');
      throw LlooMediaStorageException('Error uploading avatar', underlyingError: e);
    }
  }

  Future<String> saveFile(String filePath, String storagePath, {MediaType? type}) async {
    try {
      final ref = _storage.ref().child(storagePath);
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: type != null ? {'type': type.name} : null,
      );
      
      final task = await ref.putFile(File(filePath), metadata);
      return await task.ref.getDownloadURL();
    } catch (e) {
      L.error('MEDIA_STORAGE', 'Error saving file: $e');
      throw LlooMediaStorageException('Failed to save file: $e');
    }
  }

  Future<String> saveUrlToStorage(String url, String storagePath, {MediaType? type}) async {
    try {
      // Download the file to temp directory first
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${storagePath.split('/').last}');
      
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      
      await tempFile.writeAsBytes(response.data);
      
      // Now save it to Firebase Storage
      return await saveFile(tempFile.path, storagePath, type: type);
    } catch (e) {
      L.error('MEDIA_STORAGE', 'Error saving URL to storage: $e');
      throw LlooMediaStorageException('Failed to save URL to storage: $e');
    }
  }
}
