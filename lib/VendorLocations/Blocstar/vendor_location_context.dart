import 'package:blocstar/BlocstarContextBase.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';

class VendorLocationContext extends BlocstarContextBase<VendorLocationContext> {
  final VendorLocationModel vendorLocationModel;
  final bool savedSuccessfully;
  VendorLocationContext(super.logic,
      {required this.savedSuccessfully, required this.vendorLocationModel});

  @override
  merge(
      {VendorLocationModel? newVendorLocationModel,
      bool? newSavedSuccessfully}) {
    VendorLocationContext(
      super.logic,
      vendorLocationModel: newVendorLocationModel ?? vendorLocationModel,
      savedSuccessfully: newSavedSuccessfully ?? savedSuccessfully,
    );
  }
}
