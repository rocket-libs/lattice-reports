// Auto generated file, change at risk of code getting overwritten later

// ignore_for_file: prefer_null_aware_operators

import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Dataflow/model.dart';
import 'package:lattice_reports/Locations/Data/location_model.dart';
import 'package:preflection/MapReader.dart';
import 'package:preflection/Preflectable.dart';

class VendorLocationModel extends Model<VendorLocationModel> {
  final String? displayLabel;
  final String? contactPhoneNumber;
  final LocationModel? businessLocation;
  final LocationModel? farthestDeliveryPoint;
  final Guid? vendorUserId;
  final Guid? userGroupId;

  VendorLocationModel(
      {Guid? id,
      this.displayLabel,
      this.contactPhoneNumber,
      this.businessLocation,
      this.farthestDeliveryPoint,
      this.vendorUserId,
      this.userGroupId}) {
    this.id = id;
  }

  @override
  merge(
      {String? newDisplayLabel,
      String? newContactPhoneNumber,
      LocationModel? newBusinessLocation,
      LocationModel? newFarthestDeliveryPoint,
      Guid? newVendorUserId,
      Guid? newUserGroupId}) {
    return VendorLocationModel(
        displayLabel: resolveValue(displayLabel, newDisplayLabel),
        contactPhoneNumber:
            resolveValue(contactPhoneNumber, newContactPhoneNumber),
        businessLocation: resolveValue(businessLocation, newBusinessLocation),
        farthestDeliveryPoint:
            resolveValue(farthestDeliveryPoint, newFarthestDeliveryPoint),
        vendorUserId: resolveValue(vendorUserId, newVendorUserId),
        userGroupId: resolveValue(userGroupId, newUserGroupId),
        id: id);
  }

  @override
  VendorLocationModel singleFromMap(Map<String, dynamic> map) {
    final mapReader = MapReader(map);
    return VendorLocationModel(
      displayLabel: mapReader.read<String>(_FieldNames.displayLabel),
      contactPhoneNumber:
          mapReader.read<String>(_FieldNames.contactPhoneNumber),
      businessLocation:
          mapReader.getSingle<LocationModel>(_FieldNames.businessLocation),
      farthestDeliveryPoint:
          mapReader.getSingle<LocationModel>(_FieldNames.farthestDeliveryPoint),
      vendorUserId: mapReader.read<Guid>(_FieldNames.vendorUserId),
      userGroupId: mapReader.read<Guid>(_FieldNames.userGroupId),
      id: mapReader.read<Guid>(idFieldName),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      _FieldNames.displayLabel: displayLabel,
      _FieldNames.contactPhoneNumber: contactPhoneNumber,
      _FieldNames.businessLocation:
          businessLocation != null ? businessLocation?.toJson() : null,
      _FieldNames.farthestDeliveryPoint: farthestDeliveryPoint != null
          ? farthestDeliveryPoint?.toJson()
          : null,
      _FieldNames.vendorUserId:
          vendorUserId != null ? vendorUserId?.value : Guid.defaultValue.value,
      _FieldNames.userGroupId:
          userGroupId != null ? userGroupId?.value : Guid.defaultValue.value,
      idFieldName: id != null ? id!.value : Guid.defaultValue.value,
    };
  }
}

class _FieldNames {
  static const String displayLabel = "displayLabel";
  static const String contactPhoneNumber = "contactPhoneNumber";
  static const String businessLocation = "businessLocation";
  static const String farthestDeliveryPoint = "farthestDeliveryPoint";
  static const String vendorUserId = "vendorUserId";
  static const String userGroupId = "userGroupId";
}
