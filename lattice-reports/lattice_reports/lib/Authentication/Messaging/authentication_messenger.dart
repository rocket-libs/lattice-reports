import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Messaging/messenger.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_api_caller.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';

import '../Data/authentication_information.dart';

class AuthenticationMessenger extends Messenger<AuthenticationInformation> {
  // static const String _key = "latticeAuth";
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

  // set vendorLocationId(Guid value) {
  //   authenticationInformation.vendorLocationId = value;
  //   setAuthenticationInformationAsync(authenticationInformation);
  // }

  // set phoneNumber(String value) {
  //   authenticationInformation.phoneNumber = value;
  //   setAuthenticationInformationAsync(authenticationInformation);
  // }

  AuthenticationInformation get authenticationInformation {
    if (many.isEmpty) {
      return AuthenticationInformation(
          userProfileId: Guid.defaultValue,
          userSessionId: Guid.defaultValue,
          vendorLocationId: Guid.defaultValue,
          phoneNumber: "",
          userId: Guid.defaultValue);
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

  // setAuthenticationInformationAsync(AuthenticationInformation value) async {
  //   final sharedPrefs = await SharedPreferences.getInstance();

  //   final json = jsonEncode(value.toJson());
  //   if (!(await sharedPrefs.setString(_key, json))) {
  //     throw Exception("Could not save authentication information.");
  //   }

  //   many = [value];
  // }

  // signOutAsync() async {
  //   final sharedPrefs = await SharedPreferences.getInstance();
  //   if (!(await sharedPrefs.remove(_key))) {
  //     throw Exception("Could not remove authentication information.");
  //   }
  //   many = [
  //     AuthenticationInformation(
  //         userProfileId: Guid.defaultValue,
  //         userSessionId: Guid.defaultValue,
  //         vendorLocationId: Guid.defaultValue,
  //         phoneNumber: "",
  //         userId: Guid.defaultValue)
  //   ];
  // }
}
