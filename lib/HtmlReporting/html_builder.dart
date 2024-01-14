import 'package:lattice_reports/HtmlReporting/css_builder.dart';

class HtmlBuilder {
  final CssBuilder cssBuilder;
  final List<String> _lines = List<String>.empty(growable: true);
  final List<String> _fonts = List<String>.empty(growable: true);

  HtmlBuilder({required this.cssBuilder});

  HtmlBuilder addLine(String line) {
    _lines.add(line);
    return this;
  }

  HtmlBuilder addFont(String font) {
    _fonts.add(font);
    return this;
  }

  String build({String title = ""}) {
    final StringBuffer sb = StringBuffer();
    sb.writeln("<html>");
    sb.writeln("<head>");
    sb.writeln("<meta charset=\"utf-8\">");
    sb.writeln(
        "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
    sb.writeln("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">");
    sb.writeln("<title>$title</title>");

    for (var specificFont in _fonts) {
      sb.writeln(specificFont);
    }
    sb.writeln("<style>");
    sb.writeln(cssBuilder.build());
    sb.writeln("</style>");
    sb.writeln("</head>");
    sb.writeln("<body>");
    for (var element in _lines) {
      sb.writeln(element);
    }
    sb.writeln("</body>");
    sb.writeln("</html>");
    return sb.toString();
  }
}
