import 'package:intl/intl.dart';
import 'package:lloo_mobile/app/modules/user/models/wallet_transaction.dart';
import 'package:lloo_mobile/app/core/utils/formatting.dart';

import '../widgets/wallet_entities_table.dart';



/// Collection of functions for converting normalising
/// and formatting entity values in order to print in the URI



WalletEntitiesTableRow tableRowFromTransaction(WalletTransaction tx, {bool isFirst = false}) {
  switch (tx) {
    case AttnMarketTransaction market:
      return WalletEntitiesTableRow(
        iconName: market.icon,
        titleLabel: market.isBuy ? 'Buy ATTN' : 'Sell ATTN',
        subtitleLabel: formatTimestamp(market.timestamp),
        valueLine1: '${market.isBuy ? '+' : ''}${formattedAttnPrice(market.attnAmount)} ATTN',
        valueLine2: '${market.isBuy ? '' : ''}${formattedUSDPrice(market.fiatAmount)}',
      );

    case MemoryStakeTransaction stake:
      return WalletEntitiesTableRow(
        iconName: stake.icon,
        titleLabel: stake.memoryLabel,
        subtitleLabel: formatTimestamp(stake.timestamp),
        valueLine1: '${stake.isBuy ? '+' : ''}${formattedAttnPrice(stake.attnAmount)} ATTN',
        valueLine2: '',
      );

    case LinkStakeTransaction link:
      return WalletEntitiesTableRow(
        iconName: link.icon,
        titleLabel: '${link.memoryALabel} <>︎ ${link.memoryBLabel}',
        subtitleLabel: formatTimestamp(link.timestamp),
        valueLine1: '-${link.attnAmount.toStringAsFixed(2)} ATTN',
        valueLine2: '${link.memoryAId} ↔ ${link.memoryBId}',
      );

    case AttnTransferTransaction transfer:
      return WalletEntitiesTableRow(
        iconName: transfer.icon,
        titleLabel: transfer.isSend ? 'Sent ATTN to ${transfer.theirWalletId}' : 'Received ATTN from ${transfer.theirWalletId}',
        subtitleLabel:formatTimestamp(transfer.timestamp),
        valueLine1: '${transfer.isSend ? '' : '+'}${formattedAttnPrice(transfer.attnAmount)} ATTN',
        valueLine2: '',
      );

    default:
      return WalletEntitiesTableRow(
        iconName: tx.icon,
        titleLabel: 'Transaction',
        subtitleLabel: '',
        valueLine1: tx.transactionId,
      );
  }
}