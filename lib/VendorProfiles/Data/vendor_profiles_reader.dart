import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Dataflow/endpoint_caller.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:preflection/Preflectable.dart';
import 'package:preflection/Serializer.dart';

class VendorProfilesReader {
  String get _apiBaseRoute => "v1/VendorProfiles/";

  Future<VendorProfileModel> getAsync({bool fetchFromRemote = false}) async {
    final list =
        await getAllAsync<VendorProfileModel>(fetchFromRemote: fetchFromRemote);
    if (list.isEmpty) return VendorProfileModel();
    return list[0];
  }

  Future<List<TResult>> getAllAsync<TResult extends Preflectable<TResult>>(
      {bool fetchFromRemote = false}) async {
    final userProfileId =
        AuthenticationMessenger().authenticationInformation.userProfileId;
    final apiCaller = EndpointCaller.lattice();
    final mapResult = await apiCaller.getAsync(
        '${_apiBaseRoute}get-by-id?vendorId=$userProfileId&includeArchived=true',
        offlineDisplayLabel: null);
    final vendorProfileModel = Serializer.deserializeSingle<TResult>(mapResult);
    return [vendorProfileModel as TResult];
  }
}
