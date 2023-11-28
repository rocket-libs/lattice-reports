class LoggerWrapper {
  void Function(String message)? _i;
  void Function(String message)? _v;
  void Function(String message)? _e;

  LoggerWrapper._privateConstructor();

  static final LoggerWrapper _instance = LoggerWrapper._privateConstructor();

  factory LoggerWrapper() => _instance;

  configure(
      {required void Function(String message) i,
      required void Function(String message) v,
      required void Function(String message) e}) {
    _i = i;
  }

  get i {
    if (_i == null) {
      throw Exception("LoggerWrapper is not configured.");
    }
    return _i;
  }

  get v {
    if (_v == null) {
      throw Exception("LoggerWrapper is not configured.");
    }
    return _v;
  }

  get e {
    if (_e == null) {
      throw Exception("LoggerWrapper is not configured.");
    }
    return _e;
  }
}
