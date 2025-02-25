import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcessingDialog extends StatelessWidget {
  static final _message = ''.obs;
  static VoidCallback? _onDismiss;
  
  const ProcessingDialog._();

  static Future<void> show({
    required String message,
    bool barrierDismissible = false,
    VoidCallback? onDismiss,
  }) {
    if (Get.isDialogOpen ?? false) {
      _message.value = message;
      _onDismiss = onDismiss;
      return Future.value();
    }

    _message.value = message;
    _onDismiss = onDismiss;

    return Get.dialog(
      const ProcessingDialog._(),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _onDismiss != null,
      onPopInvoked: (didPop) {
        if (didPop && _onDismiss != null) {
          _onDismiss!();
        }
      },
      child: AlertDialog(
        backgroundColor: Colors.black87.withAlpha(100),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              Obx(() => Text(
                _message.value,
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
