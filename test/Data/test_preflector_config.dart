import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:preflection/PreflectorTypeParsers.dart';
import 'package:preflection/preflection.dart';

class TestPreflectorConfig {
  static configureForTest() {
    PreflectorTypeParsers.instance
        .registerInBuiltParsers()
        .register<Guid>((value) {
      if (value != null) {
        return Guid(value);
      } else {
        return value;
      }
    }).register<Guid?>((value) {
      if (value != null) {
        return Guid(value);
      } else {
        return Guid.defaultValue;
      }
    });

    PreflectorFactory.instance.addCreator(() => OrderDataPointModel());
  }
}
