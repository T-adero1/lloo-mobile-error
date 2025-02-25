import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:lloo_mobile/app/core/services/leonardo_ai_service.dart';
import 'package:lloo_mobile/app/core/services/media_storage_service.dart';
import 'package:lloo_mobile/app/modules/user/services/user_api.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/core/lloo_exceptions.dart';

enum AvatarGenerationStatus {
  starting,
  imageCropped,
  originalSaved,
  aiAvatarGenerated,
  aiAvatarSaved,
  completed,
  error,
}

class AvatarGenerationUpdate {
  final AvatarGenerationStatus status;
  final String? error;
  final String? url;

  AvatarGenerationUpdate({
    required this.status,
    this.error,
    this.url,
  });
}

/// @TODO: #low-p Really this is a controller. Services shouldnt be quite so smart
class AvatarGeneratorBackgroundService extends GetxService {
  final LeonardoAIService _leonardoAI = Get.find();
  final MediaStorageService _mediaStorage = Get.find();
  final UserState _userState = Get.find();
  final UserApi _userApi = Get.find();

  StreamController<AvatarGenerationUpdate>? _currentGeneration;
  
  @override
  void onClose() {
    _currentGeneration?.close();
    super.onClose();
  }

  Future<String> _cropAndSaveImage(String imagePath) async {
    // Load the image
    final bytes = await File(imagePath).readAsBytes();
    var image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    
    // Calculate crop dimensions for square
    final size = image.width < image.height ? image.width : image.height;
    final x = (image.width - size) ~/ 2;
    final y = (image.height - size) ~/ 2;
    
    // Crop the image
    final croppedImage = img.copyCrop(image, x: x, y: y, width: size, height: size);
    
    // Save to temp file
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/cropped_avatar.jpg';
    final croppedFile = File(tempPath);
    await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
    
    return tempPath;
  }

  Stream<AvatarGenerationUpdate> generateAvatar(String imagePath) {
    // Close any existing generation
    _currentGeneration?.close();
    _currentGeneration = StreamController<AvatarGenerationUpdate>.broadcast();
    
    _generateAvatar(imagePath);
    
    return _currentGeneration!.stream;
  }

  Future<void> _generateAvatar(String imagePath) async {
    try {
      //=======================================================================
      // Step 1: Crop image
      //=======================================================================
      L.debug('AVATAR_GENERATOR', 'Starting avatar generation - cropping image');
      final croppedPath = await _cropAndSaveImage(imagePath);
      // Convert path to url
      final croppedUrl = 'file://$croppedPath';
      L.debug('AVATAR_GENERATOR', '...Image cropped to URL: $croppedUrl (Path: $croppedPath');
      _currentGeneration?.add(AvatarGenerationUpdate(status: AvatarGenerationStatus.imageCropped, url: croppedUrl));

      //=======================================================================
      // Step 2: Save original to storage and update user
      //=======================================================================
      L.debug('AVATAR_GENERATOR', 'Saving original image to storage...');
      final originalUrl = await _mediaStorage.saveFile(
        croppedPath,
        'avatars/${_userState.userDetails.value!.userId}_original.jpg',
        type: MediaType.original
      );
      _userState.userDetails.value = _userState.userDetails.value!.copyWith(avatarUrl: originalUrl);
      await _userApi.updateUserDetails(_userState.userDetails.value!);
      _currentGeneration?.add(AvatarGenerationUpdate(status: AvatarGenerationStatus.originalSaved, url: originalUrl));
      L.debug('AVATAR_GENERATOR', '...Original image saved to storage and user updated: $originalUrl');

      //=======================================================================
      // Step 3: Generate AI avatar
      //=======================================================================
      L.debug('AVATAR_GENERATOR', 'Generating AI avatar');
      String? aiImageUrl;
      await for (final status in _leonardoAI.generateAvatar(imagePath: croppedPath)) {
        if (status.step == AIAvatarGenerationStep.complete && status.imageUrl != null) {
          aiImageUrl = status.imageUrl;
          break;
        }
        if (status.step == AIAvatarGenerationStep.error) {
          throw Exception(status.error ?? 'Failed to generate AI avatar');
        }
      }
      
      if (aiImageUrl == null) {
        throw Exception('No avatar URL returned from generation');
      }
      _currentGeneration?.add(AvatarGenerationUpdate(status: AvatarGenerationStatus.aiAvatarGenerated));

      //=======================================================================
      // Step 4: Save AI avatar to storage and update user
      //=======================================================================
      L.debug('AVATAR_GENERATOR', 'Saving AI avatar to storage');
      final savedAiUrl = await _mediaStorage.saveUrlToStorage(
        aiImageUrl,
        'avatars/${_userState.userDetails.value!.userId}_aiphoto.jpg',
        type: MediaType.aiPhoto
      );
      _userState.userDetails.value = _userState.userDetails.value!.copyWith(avatarUrl: savedAiUrl);
      await _userApi.updateUserDetails(_userState.userDetails.value!);
      _currentGeneration?.add(AvatarGenerationUpdate(status: AvatarGenerationStatus.aiAvatarSaved, url: savedAiUrl));
      
      //=======================================================================
      // DONE
      //=======================================================================
      _currentGeneration?.add(AvatarGenerationUpdate(
        status: AvatarGenerationStatus.completed,
        url: savedAiUrl
      ));

      Get.snackbar(
        'Success',
        'Your AI avatar has been generated!',
        duration: Duration(seconds: 3),
      );
      
    } on LlooException catch (e) {
      //=======================================================================
      // ERROR
      //=======================================================================
      L.error('AVATAR_GENERATOR', 'Error generating avatar: $e');
      _currentGeneration?.add(AvatarGenerationUpdate(
        status: AvatarGenerationStatus.error,
        error: e.toString()
      ));

      Get.snackbar(
        'Error',
        'Failed to generate avatar: $e',
        duration: Duration(seconds: 3),
      );
    } finally {
      await _currentGeneration?.close();
      _currentGeneration = null;
    }
  }
}
