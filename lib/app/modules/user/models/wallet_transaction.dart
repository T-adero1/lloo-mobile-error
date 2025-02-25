// Base Transaction class
abstract class WalletTransaction {
  final DateTime timestamp;
  final String transactionId;
  final String icon;

  WalletTransaction({
    required this.icon
  })  : timestamp = DateTime.now(),
        transactionId = DateTime.now().millisecondsSinceEpoch.toString();
}

// ATTN Market Transaction
class AttnMarketTransaction extends WalletTransaction {
  final double attnAmount;
  final double fiatAmount;

  bool get isBuy => attnAmount > 0; // true for buy, false for sell

  AttnMarketTransaction({
    required this.attnAmount,
    required this.fiatAmount,
  }) : super(icon: 'wallet');

  @override
  String toString() {
    final operation = isBuy ? 'Buy' : 'Sell';
    return '$operation: $attnAmount ATTN for $fiatAmount FIAT';
  }
}

/// Memory Staking Transaction
// TODO: Use Memory object
class MemoryStakeTransaction extends WalletTransaction {
  final String memoryId;
  final String memoryLabel;
  final double attnAmount;

  bool get isBuy => attnAmount > 0;


  MemoryStakeTransaction({
    required this.memoryId,
    required this.memoryLabel,
    required this.attnAmount,
  }) : super(icon: 'links');

  @override
  String toString() {
    return 'Stake: $attnAmount ATTN on memory "$memoryLabel" ($memoryId)';
  }
}

/// Link Staking Transaction
// @TODO: Make this use MemoryLink
class LinkStakeTransaction extends WalletTransaction {
  final String memoryAId;
  final String memoryBId;
  final String memoryALabel;
  final String memoryBLabel;
  final double attnAmount;

  LinkStakeTransaction({
    required this.memoryAId,
    required this.memoryBId,
    required this.memoryALabel,
    required this.memoryBLabel,
    required this.attnAmount,
  }) : super(icon: '2link');

  @override
  String toString() {
    return 'Link Stake: $attnAmount ATTN on link between "$memoryALabel" and "$memoryBLabel"';
  }
}

// ATTN Transfer Transaction
class AttnTransferTransaction extends WalletTransaction {
  final String myWalletId;
  final String theirWalletId;
  final double attnAmount;
  bool get isSend => attnAmount < 0.0;

  AttnTransferTransaction({
    required this.myWalletId,
    required this.theirWalletId,
    required this.attnAmount,
  }) : super(icon: 'transfer');

  @override
  String toString() {
    return 'Transfer: $attnAmount ATTN from $theirWalletId to my wallet id $myWalletId';
  }
}