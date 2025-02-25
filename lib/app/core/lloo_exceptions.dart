/// Base exception class for LLOO application
class LlooException implements Exception {
  final String message;
  final dynamic underlyingError;

  const LlooException(this.message, {this.underlyingError});

  @override
  String toString() {
    if (underlyingError != null) {
      return 'LLOOException: $message (Underlying: $underlyingError)';
    }
    return 'LLOOException: $message';
  }
}

// ---------------------------------------------------------------------

/// Exception thrown when there is an error parsing a json string
class LlooParseException extends LlooException {
  const LlooParseException(super.message, {super.underlyingError});
}

/// Exception thrown when there is an API error
class LlooApiException extends LlooException {
  const LlooApiException(super.message, {super.underlyingError});
}

/// Exception thrown when there is an error with media storage operations
class LlooMediaStorageException extends LlooException {
  const LlooMediaStorageException(super.message, {super.underlyingError});
}
