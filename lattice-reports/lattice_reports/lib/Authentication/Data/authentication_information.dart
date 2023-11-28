import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';

class AuthenticationInformation {
  Guid userProfileId;
  Guid userSessionId;
  Guid vendorLocationId = Guid.defaultValue;
  String phoneNumber = "";
  Guid userId;
  Guid get userGroupId => userProfileId;

  AuthenticationInformation(
      {required this.userProfileId,
      required this.userSessionId,
      required this.vendorLocationId,
      required this.phoneNumber,
      required this.userId});

  static Guid toGuid(String name, Map<String, dynamic> json) {
    return Guid(json[name]);
  }

  AuthenticationInformation.fromJson(Map<String, dynamic> json)
      : userProfileId = Guid(json["userProfileId"]),
        userSessionId = toGuid("userSessionId", json),
        userId = toGuid("userId", json),
        vendorLocationId = toGuid(
          "vendorLocationId",
          json,
        ),
        phoneNumber = json["phoneNumber"] ?? "";

  bool get isSignedIn {
    return userSessionId != Guid.defaultValue &&
        userProfileId != Guid.defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      "userProfileId": userProfileId.value,
      "userSessionId": userSessionId.value,
      "vendorLocationId": vendorLocationId.value,
      "phoneNumber": phoneNumber.valueOrDefault(),
      "userId": userId.value
    };
  }
}
