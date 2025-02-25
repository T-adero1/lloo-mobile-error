// wallet_styles.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kWalletStylesSectionSpacing = 32.0;

const kWalletStylesHeaderBottomMargin = 4.0;
const kWalletStylesInputSpacing = 4.0;

class WalletStyles {
  static const TextStyle holdingsLabelFont = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle holdingsValueFont = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle transactionTitleFont = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle transactionSubtitleFont = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle transactionAmountFont = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}