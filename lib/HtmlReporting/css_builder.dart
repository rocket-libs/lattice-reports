class CssBuilder {
  final Map<String, String> _classes = {};
  final Map<String, String> _mobileClasses = {};

  CssBuilder addToClass(String className, String largeScreen,
      {String? mobile}) {
    if (!_classes.containsKey(className)) {
      _classes[className] = "";
    }
    final String existing = _classes[className]!;
    _classes[className] = "$existing\t$largeScreen";
    if (mobile != null) {
      _addToMobileClass(className, mobile);
    }
    return this;
  }

  CssBuilder _addToMobileClass(String className, String line) {
    if (!_mobileClasses.containsKey(className)) {
      _mobileClasses[className] = "";
    }
    final String existing = _mobileClasses[className]!;
    _mobileClasses[className] = "$existing\t$line";
    return this;
  }

  String build() {
    final StringBuffer sb = StringBuffer();

    _classes.forEach((key, value) {
      sb.writeln("$key {");
      sb.writeln(value);
      sb.writeln("}");
    });

    _mobileClasses.forEach((key, value) {
      sb.writeln("@media only screen and (max-width: 600px) {");
      sb.writeln("$key {");
      sb.writeln(value);
      sb.writeln("}");
      sb.writeln("}");
    });

    return sb.toString();
  }
}
