import 'package:blocstar/BlocstarContextBase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';

class SalesListContext extends BlocstarContextBase<SalesListContext> {
  final Guid userProfileId;
  final List<OrderDataPointModel> sales;
  final ReportArgumentModel reportArgumentModel;
  final VendorProfileModel vendorProfileModel;
  SalesListContext(super.logic,
      {required this.vendorProfileModel,
      required this.reportArgumentModel,
      required this.userProfileId,
      required this.sales});

  @override
  merge(
      {Guid? newUserProfileId,
      List<OrderDataPointModel>? newSales,
      ReportArgumentModel? newReportArgumentModel,
      VendorProfileModel? newVendorProfileModel}) {
    return SalesListContext(logic,
        userProfileId: newUserProfileId ?? userProfileId,
        sales: newSales ?? sales,
        reportArgumentModel: newReportArgumentModel ?? reportArgumentModel,
        vendorProfileModel: newVendorProfileModel ?? vendorProfileModel);
  }
}
