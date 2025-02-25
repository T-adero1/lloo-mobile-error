import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lloo_mobile/config.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:dio/dio.dart';

/// Represents the current status of avatar generation
enum AIAvatarGenerationStep {
  uploadingImage,
  creatingGeneration,
  generatingImage,
  complete,
  error
}

/// Status update for the avatar generation process
class AIAvatarGenerationStatus {
  final AIAvatarGenerationStep step;
  final String? message;
  final String? imageUrl;
  final dynamic error;

  AIAvatarGenerationStatus({
    required this.step,
    this.message,
    this.imageUrl,
    this.error,
  });
}

class LeonardoAIService {
  static const String _baseUrl = 'https://cloud.leonardo.ai/api/rest/v1';

  final String _apiKey;
  final String _modelId;
  final double _characterStrength;
  final String _prompt;
  final _dio = Get.find<Dio>();

  LeonardoAIService({
    required String apiKey,
    required String modelId,
    required double characterStrength,
    required String prompt,
  }) : _apiKey = apiKey,
        _modelId = modelId,
        _characterStrength = characterStrength,
        _prompt = prompt;

  Map<String, String> get _headers => {
    'accept': 'application/json',
    'content-type': 'application/json',
    'authorization': 'Bearer $_apiKey',
  };

  /// Generates an avatar using Leonardo AI with the given parameters
  /// Returns a stream of status updates about the generation process
  Stream<AIAvatarGenerationStatus> generateAvatar({
    required String imagePath,
    String? modelId,
    double? initStrength,
    int? numImages = 1,
    int width = 512,
    int height = 512,
  }) async* {
    try {
      L.info('AI_AVATAR_MAKER', 'Starting avatar generation with prompt: $_prompt');
      L.debug('AI_AVATAR_MAKER', 'Parameters: width=$width, height=$height, modelId=${modelId ?? _modelId}, strength=${initStrength ?? _characterStrength}');

      // Step 1: Upload image
      yield AIAvatarGenerationStatus(
        step: AIAvatarGenerationStep.uploadingImage,
        message: 'Uploading reference image...',
      );

      final uploadResponse = await _dio.post(
        '$_baseUrl/init-image',
        options: Options(headers: _headers),
        data: jsonEncode({'extension': 'jpg'}),
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception('Failed to get upload URL: ${uploadResponse.data}');
      }

      final uploadData = uploadResponse.data;
      final fields = jsonDecode(uploadData['uploadInitImage']['fields']);
      final uploadUrl = uploadData['uploadInitImage']['url'];
      final uploadedImageId = uploadData['uploadInitImage']['id'];

      L.debug('AI_AVATAR_MAKER', 'Got upload URL, image ID: $uploadedImageId');

      // Upload the actual image
      final imageFile = File(imagePath);
      final uploadRequest = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields.addAll(fields.cast<String, String>())
        ..files.add(await http.MultipartFile.fromPath('file', imagePath));

      final imageUploadResponse = await uploadRequest.send();
      if (imageUploadResponse.statusCode != 204) {
        throw Exception('Failed to upload image');
      }

      L.debug('AI_AVATAR_MAKER', 'Image uploaded successfully');

      // Step 2: Create generation with ControlNet
      yield AIAvatarGenerationStatus(
        step: AIAvatarGenerationStep.creatingGeneration,
        message: 'Creating image generation...',
      );

      final generationPayload = {
        'height': height,
        'width': width,
        'modelId': modelId ?? _modelId,
        'prompt': _prompt,
        'presetStyle': 'DYNAMIC',
        'num_images': numImages,
        'photoReal': true,
        'photoRealVersion': 'v2',
        'alchemy': true,
        'controlnets': [
          {
            'initImageId': uploadedImageId,
            'initImageType': 'UPLOADED',
            'preprocessorId': 133, // Character Reference  67=style ref
            'strengthType': _getStrengthType(initStrength ?? _characterStrength),
          }
        ]
      };

      L.debug('AI_AVATAR_MAKER', 'Creating generation with payload: ${jsonEncode(generationPayload)}');

      final generationResponse = await _dio.post(
        '$_baseUrl/generations',
        options: Options(headers: _headers),
        data: jsonEncode(generationPayload),
      );

      if (generationResponse.statusCode != 200) {
        throw Exception('Failed to create generation: ${generationResponse.data}');
      }

      final generationId = generationResponse.data['sdGenerationJob']['generationId'];
      L.debug('AI_AVATAR_MAKER', 'Generation created, ID: $generationId');

      // Step 3: Poll for results
      yield AIAvatarGenerationStatus(
        step: AIAvatarGenerationStep.generatingImage,
        message: 'Generating avatar...',
      );

      String? imageUrl;
      bool isComplete = false;
      int attempts = 0;
      const maxAttempts = 30;

      while (!isComplete && attempts < maxAttempts) {
        await Future.delayed(Duration(seconds: 5));
        L.debug('AI_AVATAR_MAKER', 'Checking generation status (attempt ${attempts + 1}/$maxAttempts)');

        final statusResponse = await _dio.get(
          '$_baseUrl/generations/$generationId',
          options: Options(headers: _headers),
        );

        if (statusResponse.statusCode != 200) {
          throw Exception('Failed to check generation status: ${statusResponse.data}');
        }

        final statusData = statusResponse.data;
        final status = statusData['generations_by_pk'];
        L.debug('AI_AVATAR_MAKER', 'Generation status: ${status['status']}');

        if (status['status'] == 'COMPLETE') {
          final images = status['generated_images'];
          if (images != null && images.isNotEmpty) {
            imageUrl = images[0]['url'];
            isComplete = true;
            L.info('AI_AVATAR_MAKER', 'Generation complete! Image URL: $imageUrl');
          }
        } else if (status['status'] == 'FAILED') {
          throw Exception('Generation failed: ${status['message']}');
        }

        attempts++;
      }

      if (imageUrl == null) {
        throw Exception('Generation timed out');
      }

      yield AIAvatarGenerationStatus(
        step: AIAvatarGenerationStep.complete,
        message: 'Avatar generated successfully!',
        imageUrl: imageUrl,
      );

    } catch (e, stackTrace) {
      L.error('AI_AVATAR_MAKER', "Error generating avatar: $e");
      yield AIAvatarGenerationStatus(
        step: AIAvatarGenerationStep.error,
        message: 'Failed to generate avatar',
        error: e,
      );
    }
  }

  String _getStrengthType(double strength) {
    if (strength <= 0.3) return 'Low';
    if (strength <= 0.7) return 'Mid';
    return 'High';
  }
}
