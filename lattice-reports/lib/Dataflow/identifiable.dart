import 'package:flutter_guid/flutter_guid.dart';

mixin Identifiable {
  final String idFieldName = "id";
  Guid? id = Guid("");
}
