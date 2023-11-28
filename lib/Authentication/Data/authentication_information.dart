import 'package:flutter_guid/flutter_guid.dart';

class AuthenticationInformation {
  Guid userProfileId;
  Guid userSessionId;
  Guid vendorLocationId = Guid.defaultValue;

  Guid get userGroupId => userProfileId;

  AuthenticationInformation({
    required this.userProfileId,
    required this.userSessionId,
    required this.vendorLocationId,
  });

  static Guid toGuid(String name, Map<String, dynamic> json) {
    return Guid(json[name]);
  }

  AuthenticationInformation.fromJson(Map<String, dynamic> json)
      : userProfileId = Guid(json["userProfileId"]),
        userSessionId = toGuid("userSessionId", json),
        vendorLocationId = toGuid(
          "vendorLocationId",
          json,
        );

  bool get isSignedIn {
    return userSessionId != Guid.defaultValue &&
        userProfileId != Guid.defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      "userProfileId": userProfileId.value,
      "userSessionId": userSessionId.value,
      "vendorLocationId": vendorLocationId.value,
    };
  }
}
