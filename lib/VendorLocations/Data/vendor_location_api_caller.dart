import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Dataflow/endpoint_caller.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:preflection/Serializer.dart';

import 'vendor_location_model.dart';

class VendorLocationApiCaller {
  Future<List<VendorLocationModel>> getAllAsync(
      {required Guid vendorId}) async {
    final endpointCaller = EndpointCaller.lattice();

    final response = await endpointCaller
        .getAsync("v1/VendorLocations/get-all-for-vendor?vendorId=$vendorId");
    final vendorLocations =
        Serializer.deserializeMany<VendorLocationModel>(response)
            .toNonNullList();
    AuthenticationMessenger().vendorLocations.clear();
    for (var specificVendorLocation in vendorLocations) {
      AuthenticationMessenger().vendorLocations.add(specificVendorLocation);
    }
    return AuthenticationMessenger().vendorLocations;
  }

  Future<Guid> saveAsync({required VendorLocationModel vendorLocation}) async {
    final endpointCaller = EndpointCaller.lattice();

    final response = await endpointCaller.postModelAsync(
        "v1/VendorLocations/save", vendorLocation);
    return Guid(response);
  }
}
