import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Messaging/messenger.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_api_caller.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';

import '../Data/authentication_information.dart';

class AuthenticationMessenger extends Messenger<AuthenticationInformation> {
  final List<VendorLocationModel> vendorLocations = [];
  bool _isFetchingVendorLocations = false;
  Future<AuthenticationInformation> Function()? _getAuthenticationInformation;

  AuthenticationMessenger._() {
    refreshAsync();
  }

  configure(
      {required Future<AuthenticationInformation> Function()
          getAuthenticationInformation,
      required AuthenticationInformation authenticationInformation}) {
    _getAuthenticationInformation = getAuthenticationInformation;
    single = authenticationInformation;
  }

  static final AuthenticationMessenger _instance = AuthenticationMessenger._();

  factory AuthenticationMessenger() => _instance;

  @override
  String get name => "AuthenticationStream";

  @override
  Future refreshAsync() async {
    try {
      if (_getAuthenticationInformation == null) {
        throw Exception("Authentication messenger is not configured.");
      }
      single = await _getAuthenticationInformation!();
    } finally {
      await fetchVendorLocationsAsync();
    }
  }

  AuthenticationInformation get authenticationInformation {
    if (many.isEmpty) {
      return AuthenticationInformation(
        userProfileId: Guid.defaultValue,
        userSessionId: Guid.defaultValue,
        vendorLocationId: Guid.defaultValue,
      );
    } else {
      return many.first;
    }
  }

  Future fetchVendorLocationsAsync() async {
    if (_isFetchingVendorLocations) {
      return;
    }
    _isFetchingVendorLocations = true;
    try {
      if (authenticationInformation.isSignedIn == false) {
        return;
      }

      if (vendorLocations.isNotEmpty) {
        return;
      }

      final vendorLocationApiCaller = VendorLocationApiCaller();
      vendorLocations.clear();
      vendorLocations.addAll(await vendorLocationApiCaller.getAllAsync(
          vendorId: authenticationInformation.userProfileId));
    } finally {
      _isFetchingVendorLocations = false;
    }
  }

  VendorLocationModel? get vendorLocation {
    if (vendorLocations.isEmpty) {
      return null;
    } else {
      return vendorLocations.firstWhere(
          (element) => element.id == authenticationInformation.vendorLocationId,
          orElse: () => vendorLocations.first);
    }
  }
}
