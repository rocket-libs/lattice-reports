import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Blocstar/report_context_base.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';

class RevenueListContext extends ReportContextBase<RevenueListContext> {
  final Guid userProfileId;
  final List<OrderDataPointModel> orderDataPointModels;
  final Set<String> paymentMethods;
  final Set<String> selectedPaymentMethods;

  RevenueListContext(super.logic,
      {required this.paymentMethods,
      required this.selectedPaymentMethods,
      required this.userProfileId,
      required this.orderDataPointModels,
      required super.reportArgumentModel,
      required super.vendorProfileModel});

  @override
  merge(
      {Guid? newUserProfileId,
      ReportArgumentModel? newReportArgumentModel,
      VendorProfileModel? newVendorProfileModel,
      List<OrderDataPointModel>? newOrderDataPointModels,
      Set<String>? newPaymentMethods,
      Set<String>? newSelectedPaymentMethods}) {
    return RevenueListContext(logic,
        userProfileId: newUserProfileId ?? userProfileId,
        reportArgumentModel: newReportArgumentModel ?? reportArgumentModel,
        vendorProfileModel: newVendorProfileModel ?? vendorProfileModel,
        orderDataPointModels: newOrderDataPointModels ?? orderDataPointModels,
        paymentMethods: newPaymentMethods ?? paymentMethods,
        selectedPaymentMethods:
            newSelectedPaymentMethods ?? selectedPaymentMethods);
  }
}
