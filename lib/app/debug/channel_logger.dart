import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class CustomPrinter extends LogPrinter {
  static final _levelEmojis = {
    Level.verbose: '🔍 VERBOSE', // Level.verbose
    Level.trace: '📈 TRACE',
    Level.debug: '🐛 DEBUG',   // Level.debug
    Level.info: 'ℹ️ INFO',    // Level.info
    Level.warning: '⚠️ WARN',    // Level.warning
    Level.error: '❌ ERROR',   // Level.error
  };

  final _timeFormatter = DateFormat('HH:mm:ss.SSS');


  @override
  List<String> log(LogEvent event) {
    String timeStr = _timeFormatter.format(DateTime.now());
    String levelStr = _levelEmojis[event.level] ?? 'UNKNOWN';

    // Extract domain from the message (assumes message starts with '[DOMAIN]')
    final domainMatch = RegExp(r'\[(.*?)\]').firstMatch(event.message);
    final domain = domainMatch?.group(1) ?? '';

    // Remove the domain prefix from the message
    final cleanMessage = event.message.replaceFirst(RegExp(r'\[.*?\]\s*'), '');

    return ['[$domain] $timeStr  $levelStr  $cleanMessage'];
  }
}

class ChannelLogger {
  static final _logger = Logger(printer: CustomPrinter());

  static List<String>? _includeChannels;
  static List<String> _excludeChannels = [];

  static void configure({
    List<String>? includeChannels,
    List<String>? excludeChannels,
  }) {
    _includeChannels = includeChannels;
    _excludeChannels = excludeChannels ?? [];
  }

  static bool _shouldLog(String domain) {
    if (_excludeChannels.any((pattern) =>
        RegExp(pattern).hasMatch(domain))) {
      return false;
    }

    if (_includeChannels == null) {
      return true;
    }

    return _includeChannels!.any((pattern) =>
        RegExp(pattern).hasMatch(domain));
  }

  static void log(String domain, Level level, String message, [dynamic object]) {
    if (!_shouldLog(domain)) return;

    final prefix = '[${domain.toUpperCase()}]';
    final output = object != null ? '$prefix $message ${object.toString()}' : '$prefix $message';

    switch (level) {
      case Level.verbose:
        _logger.v(output);
      case Level.trace:
        _logger.t(output);
      case Level.debug:
        _logger.d(output);
      case Level.info:
        _logger.i(output);
      case Level.warning:
        _logger.w(output);
      case Level.error:
        _logger.e(output);
      default:
        _logger.e("UNKNOWN LOG LEVEL");
    }
  }
}

// Convenience methods
void verbose(String domain, String message, [dynamic object]) =>
    ChannelLogger.log(domain, Level.verbose, message, object);

void trace(String domain, String message, [dynamic object]) =>
    ChannelLogger.log(domain, Level.trace, message, object);

void debug(String domain, String message, [dynamic object]) =>
    ChannelLogger.log(domain, Level.debug, message, object);

void info(String domain, String message, [dynamic object]) =>
    ChannelLogger.log(domain, Level.info, message, object);

void warn(String domain, String message, [dynamic object]) =>
    ChannelLogger.log(domain, Level.warning, message, object);

void error(String domain, String message, [dynamic object]) =>
    ChannelLogger.log(domain, Level.error, message, object);

void configure({
  List<String>? includeChannels,
  List<String>? excludeChannels,
}) {
  ChannelLogger.configure(
    includeChannels: includeChannels,
    excludeChannels: excludeChannels,
  );
}