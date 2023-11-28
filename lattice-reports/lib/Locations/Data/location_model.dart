// Auto generated file, change at risk of code getting overwritten later

import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Dataflow/model.dart';
import 'package:preflection/MapReader.dart';
import 'package:preflection/Preflectable.dart';

class LocationModel extends Model<LocationModel> {
  final double? longitude;
  final double? latitude;
  final double? accuracy;
  final String? name;
  final String? displayLabel;

  LocationModel(
      {Guid? id,
      this.longitude,
      this.latitude,
      this.accuracy,
      this.name,
      this.displayLabel}) {
    this.id = id;
  }

  @override
  merge(
      {double? newLongitude,
      double? newLatitude,
      double? newAccuracy,
      String? newName,
      String? newDisplayLabel}) {
    return LocationModel(
        longitude: resolveValue(longitude, newLongitude),
        latitude: resolveValue(latitude, newLatitude),
        accuracy: resolveValue(accuracy, newAccuracy),
        name: resolveValue(name, newName),
        displayLabel: resolveValue(displayLabel, newDisplayLabel),
        id: id);
  }

  @override
  LocationModel singleFromMap(Map<String, dynamic> map) {
    final mapReader = MapReader(map);
    return LocationModel(
      longitude: mapReader.read<double>(_FieldNames.longitude),
      latitude: mapReader.read<double>(_FieldNames.latitude),
      accuracy: mapReader.read<double>(_FieldNames.accuracy),
      name: mapReader.read<String>(_FieldNames.name),
      displayLabel: mapReader.read<String>(_FieldNames.displayLabel),
      id: mapReader.read<Guid>(idFieldName),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      _FieldNames.longitude: longitude,
      _FieldNames.latitude: latitude,
      _FieldNames.accuracy: accuracy,
      _FieldNames.name: name,
      _FieldNames.displayLabel: displayLabel,
      idFieldName: id != null ? id!.value : Guid.defaultValue.value,
    };
  }
}

class _FieldNames {
  static const String longitude = "longitude";
  static const String latitude = "latitude";
  static const String accuracy = "accuracy";
  static const String name = "name";
  static const String displayLabel = "displayLabel";
}
