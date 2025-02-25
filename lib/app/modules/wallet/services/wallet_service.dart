// wallet_service.dart
import 'package:get/get.dart';
import '../wallet_state.dart';

class WalletService extends GetxService {
  final WalletState state = Get.find();
}