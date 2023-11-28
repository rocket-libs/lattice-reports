class RestException implements Exception {
  final String message;
  final Object? innerException;

  RestException({required this.message, this.innerException});

  @override
  String toString() {
    return "$message$_innerExpectionInformation";
  }

  String get _innerExpectionInformation {
    if (innerException != null) {
      return "\n\nTechnical error information logged.";
    } else {
      return "";
    }
  }
}
