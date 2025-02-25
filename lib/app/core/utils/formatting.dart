
import 'package:intl/intl.dart';
import 'package:lloo_mobile/config.dart';


/// Format prices to add thousands sep and round to kConfigAttnDecimalPlacesToPrint decimals
String formattedAttnPrice(double price) {
  final formatter = NumberFormat(
      '#,##0.${'#' * kConfigAttnDecimalPlacesToPrint}',
      Intl.getCurrentLocale()
  );
  return formatter.format(price);
}

String formattedUSDPrice(double price) {
  final formatter = NumberFormat.currency(
      locale: Intl.getCurrentLocale(),
      name: 'USD',  // e.g. 'USD', 'EUR', 'GBP'
      decimalDigits: 2
  );
  return formatter.format(price);
}

String formatTimestamp(DateTime timestamp) {
  return DateFormat('yyyy.MM.dd').format(timestamp);
}
