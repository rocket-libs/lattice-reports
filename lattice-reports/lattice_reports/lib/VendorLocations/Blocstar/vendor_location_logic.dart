import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Blocstar/logic_base.dart';
import 'package:lattice_reports/Locations/Data/location_model.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/VendorLocations/Blocstar/vendor_location_context.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_api_caller.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';

class VendorLocationLogic extends LogicBase<VendorLocationContext> {
  @override
  Future initializeAsync() async {
    context = VendorLocationContext(this,
        savedSuccessfully: false,
        vendorLocationModel: VendorLocationModel(
            userGroupId: AuthenticationMessenger()
                .authenticationInformation
                .userProfileId,
            businessLocation:
                LocationModel(latitude: 0.1, longitude: 0.1, accuracy: 0.1),
            farthestDeliveryPoint:
                LocationModel(latitude: 0.1, longitude: 0.1, accuracy: 0.1),
            vendorUserId: AuthenticationMessenger()
                .authenticationInformation
                .userId
                .valueOrDefault()));
    await super.initializeAsync();
  }

  set displayLabel(String value) {
    context.merge(
        newVendorLocationModel:
            context.vendorLocationModel.merge(newDisplayLabel: value));
  }

  set contactPhoneNumber(String value) {
    context.merge(
        newVendorLocationModel:
            context.vendorLocationModel.merge(newContactPhoneNumber: value));
  }

  bool get canCallApi =>
      context.vendorLocationModel.displayLabel.valueOrDefault().isNotEmpty &&
      context.vendorLocationModel.contactPhoneNumber != null &&
      context.vendorLocationModel.contactPhoneNumber
          .valueOrDefault()
          .isNotEmpty &&
      context.vendorLocationModel.vendorUserId.valueOrDefault() !=
          Guid.defaultValue;

  // Future saveAsync() async {
  //   await runWrappedAsync(() async {
  //     if (canCallApi) {
  //       final apiCaller = VendorLocationApiCaller();
  //       final result = await apiCaller.saveAsync(
  //         vendorLocation: context.vendorLocationModel,
  //       );
  //       context.merge(newSavedSuccessfully: Guid.isValid(result));
  //     }
  //   });
  // }
}
