import 'package:lattice_reports/Messaging/messenger.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profiles_reader.dart';

class VendorProfileMessenger extends Messenger<VendorProfileModel> {
  VendorProfileMessenger._privateConstructor();

  static final VendorProfileMessenger _instance =
      VendorProfileMessenger._privateConstructor();

  factory VendorProfileMessenger() => _instance;

  @override
  String get name => "VendorProfileMessenger";

  @override
  Future refreshAsync({bool fetchFromRemote = false}) async {
    if (many.isEmpty || fetchFromRemote) {
      single = await VendorProfilesReader()
          .getAsync(fetchFromRemote: fetchFromRemote);
    }
  }
}
