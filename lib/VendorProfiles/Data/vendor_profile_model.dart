// Auto generated file, change at risk of code getting overwritten later

import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Dataflow/model.dart';
import 'package:preflection/MapReader.dart';
import 'package:preflection/Preflectable.dart';

class VendorProfileModel extends Model<VendorProfileModel> {
  final Guid? vendorId;
  final String? description;
  final String? displayLabel;
  final String? coverPhotoFilename;

  VendorProfileModel(
      {Guid? id,
      this.vendorId,
      this.description,
      this.displayLabel,
      this.coverPhotoFilename}) {
    this.id = id;
  }

  @override
  merge(
      {Guid? newVendorId,
      String? newDescription,
      String? newDisplayLabel,
      String? newCoverPhotoFilename}) {
    return VendorProfileModel(
        vendorId: resolveValue(vendorId, newVendorId),
        description: resolveValue(description, newDescription),
        displayLabel: resolveValue(displayLabel, newDisplayLabel),
        coverPhotoFilename:
            resolveValue(coverPhotoFilename, newCoverPhotoFilename),
        id: id);
  }

  @override
  VendorProfileModel singleFromMap(Map<String, dynamic> map) {
    final mapReader = MapReader(map);
    return VendorProfileModel(
      vendorId: mapReader.read<Guid>(_FieldNames.vendorId),
      description: mapReader.read<String>(_FieldNames.description),
      displayLabel: mapReader.read<String>(_FieldNames.displayLabel),
      coverPhotoFilename:
          mapReader.read<String>(_FieldNames.coverPhotoFilename),
      id: mapReader.read<Guid>(idFieldName),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      _FieldNames.vendorId:
          vendorId != null ? vendorId?.value : Guid.defaultValue.value,
      _FieldNames.description: description,
      _FieldNames.displayLabel: displayLabel,
      _FieldNames.coverPhotoFilename: coverPhotoFilename,
      idFieldName: id != null ? id!.value : Guid.defaultValue.value,
    };
  }
}

class _FieldNames {
  static const String vendorId = "vendorId";
  static const String description = "description";
  static const String displayLabel = "displayLabel";
  static const String coverPhotoFilename = "coverPhotoFilename";
}
