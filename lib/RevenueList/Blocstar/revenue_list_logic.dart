import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Blocstar/logic_base.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/RevenueList/Blocstar/revenue_list_context.dart';
import 'package:lattice_reports/RevenueList/Data/revenue_api_caller.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:lattice_reports/VendorProfiles/Messaging/vendor_profile_messenger.dart';

class RevenueListLogic extends LogicBase<RevenueListContext> {
  bool _fetchingData = false;
  @override
  Future initializeAsync() async {
    final userProfileId = Guid.defaultValue;
    context = RevenueListContext(this,
        userProfileId: userProfileId,
        orderDataPointModels: [],
        reportArgumentModel: ReportArgumentModel(
          dateOne: DateTime.now(),
          dateTwo: DateTime.now(),
          vendorLocations: [],
        ),
        vendorProfileModel: VendorProfileMessenger()
            .getSingleOrDefault(defaultValue: VendorProfileModel()),
        paymentMethods: {},
        selectedPaymentMethods: {});
    await super.initializeAsync();
  }

  List<OrderDataPointModel> get filteredOrders {
    return _filteredByPaymentMethod;
  }

  @override
  Future runReportAsync() async {
    if (_fetchingData) {
      return;
    }
    try {
      _fetchingData = true;
      await runWrappedAsync(() async {
        final revenueApiCaller = RevenueApiCaller();
        final results =
            await revenueApiCaller.getByArbitraryDatesWithModelAsync(
                reportArgumentModel: context.reportArgumentModel);

        final paymentMethods =
            results.map((e) => e.methodOfPayment.valueOrDefault()).toSet();
        context.merge(
            newOrderDataPointModels: results,
            newPaymentMethods: paymentMethods);
      });
    } finally {
      _fetchingData = false;
    }
  }

  selectPaymentMethods(Set<String> paymentMethods) {
    context.selectedPaymentMethods.clear();
    context.merge(newSelectedPaymentMethods: paymentMethods);
  }

  List<OrderDataPointModel> get _filteredByPaymentMethod {
    if (context.selectedPaymentMethods.isEmpty) {
      return context.orderDataPointModels;
    }
    return context.orderDataPointModels.where((element) {
      final isContained =
          context.selectedPaymentMethods.contains(element.methodOfPayment);
      return isContained;
    }).toList();
  }
}
