import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lloo_mobile/app/app_routes.dart';
import 'package:lloo_mobile/app/core/base/lloo_view_controller.dart';
import 'package:lloo_mobile/app/modules/user/services/avatar_generator_service.dart';
import 'package:lloo_mobile/app/core/services/media_storage_service.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_module.dart';
import 'package:lloo_mobile/app/modules/user/user_state.dart';
import 'package:lloo_mobile/config.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import '../onboarding_state.dart';
import 'package:lloo_mobile/app/core/widgets/processing_dialog.dart';

class AvatarCameraViewController extends LlooViewController<OnboardingState> {
  final UserState _userState = Get.find();
  final AvatarGeneratorBackgroundService _avatarGenerator = Get.find();
  final MediaStorageService _mediaStorage = Get.find();
  
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  final isProcessing = false.obs;  // @TODO #hi-p move to state

  @override
  void onInit() async {
    super.onInit();

    state.cameraIsInitialized.value = false;
    await _initializeCamera();
    state.cameraIsInitialized.value = true;

    ever(state.cameraProcessingMessage, (String? message) {
      if (message != null) {
        ProcessingDialog.show(
          message: message,
          barrierDismissible: false,
          onDismiss: () {
            state.cameraProcessingMessage.value = null;
          },
        );
      } else {
        ProcessingDialog.hide();
      }
    });
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Use the front camera by default for avatar photos
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController.initialize();
      await cameraController.setFocusMode(FocusMode.auto);
      await cameraController.setExposureMode(ExposureMode.auto);
      await cameraController.setFlashMode(FlashMode.off);
    } catch (e) {
      L.error('AVATAR_CAMERA_VC', 'Error initializing camera: $e');
    }
  }

  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized) {
      L.error('AVATAR_CAMERA_VC', 'Camera not initialized');
      return;
    }

    try {
      final image = await cameraController.takePicture();
      await _processImage(image);
    } catch (e) {
      state.cameraProcessingMessage.value = null;
      Get.snackbar('Error', 'Failed to take picture: $e');
    }
  }

  Future<void> _processImage(XFile image) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    // Store the local image as the first

    try {
      final subscription = _avatarGenerator
          .generateAvatar(image.path)
          .listen((update) {
            if (update.status == AvatarGenerationStatus.imageCropped) {
              // Assign the temp local file to the user details avatar so we can move on
              _userState.userDetails.value!.copyWith(avatarUrl: update.url);
              Get.toNamed($appRoutes.onboarding.avatarGenerating);
            }

            if (update.status == AvatarGenerationStatus.error ||
            update.status == AvatarGenerationStatus.completed) {
              isProcessing.value = false;
            }
          });

      // Keep subscription active but store it for cleanup
      Get.put(subscription, tag: 'avatar_generation');


    } catch (e) {
      L.error('AVATAR_CAMERA_VC', 'Error processing image: $e');
      //@TODO: #med-p error reporting
      isProcessing.value = false;
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length <= 1) return;

    final currentLensDir = cameraController.description.lensDirection;
    CameraDescription? newCamera;

    if (currentLensDir == CameraLensDirection.front) {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
    } else {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
    }

    if (newCamera != null) {
      await cameraController.dispose();
      cameraController = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await cameraController.initialize();
      await cameraController.setFocusMode(FocusMode.auto);
      await cameraController.setExposureMode(ExposureMode.auto);
      await cameraController.setFlashMode(FlashMode.off);
      update();
    }
  }
}
