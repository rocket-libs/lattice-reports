import 'package:blocstar/BlocstarContextBase.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';

abstract class ReportContextBase<TBlocstarContext>
    extends BlocstarContextBase<TBlocstarContext> {
  final ReportArgumentModel reportArgumentModel;
  final VendorProfileModel vendorProfileModel;

  ReportContextBase(super.logic,
      {required this.reportArgumentModel, required this.vendorProfileModel});

  @override
  merge({VendorProfileModel? newVendorProfileModel});
}
