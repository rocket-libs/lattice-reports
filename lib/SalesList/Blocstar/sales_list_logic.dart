import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:lattice_reports/VendorProfiles/Messaging/vendor_profile_messenger.dart';

import '../../../Blocstar/logic_base.dart';
import '../Data/sales_list_api_caller.dart';
import 'sales_list_context.dart';

class SalesListLogic extends LogicBase<SalesListContext> {
  Function onReportRun = () {};
  @override
  Future initializeAsync() async {
    context = SalesListContext(
      vendorProfileModel: VendorProfileMessenger()
          .getSingleOrDefault(defaultValue: VendorProfileModel()),
      this,
      userProfileId: Guid.defaultValue,
      sales: [],
      reportArgumentModel: ReportArgumentModel(
        dateOne: DateTime.now(),
        dateTwo: DateTime.now(),
        vendorLocations: [],
      ),
    );
    VendorProfileMessenger().addListener(_vendorProfileModelChanged);
    await super.initializeAsync();
  }

  @override
  dispose() {
    VendorProfileMessenger().removeListener(_vendorProfileModelChanged);
    onReportRun = () {};
    super.dispose();
  }

  _vendorProfileModelChanged(List<VendorProfileModel> vendorProfileModels) {
    if (vendorProfileModels.isEmpty) {
      return;
    }
    context.merge(newVendorProfileModel: vendorProfileModels.first);
    runReportAsync();
  }

  bool get showingMultipleDates {
    return context.reportArgumentModel.dateOne.toDDDashMMMDashYYYY() !=
        context.reportArgumentModel.dateTwo.toDDDashMMMDashYYYY();
  }

  double get grandTotal {
    final result = _salesGrouped.fold<double>(
        0, (previousValue, element) => previousValue + element.lineTotal!);
    return result;
  }

  List<OrderDataPointModel> get sales {
    if (showingMultipleDates) {
      return _salesGrouped;
    } else {
      return context.sales;
    }
  }

  List<OrderDataPointModel> get _salesGrouped {
    final unGroupedSales = context.sales;
    final groupedSales = <String, OrderDataPointModel>{};

    for (var sale in unGroupedSales) {
      final key = sale.dated.toYYYYDashMMDashDD();

      if (groupedSales.containsKey(key)) {
        final newValue = groupedSales[key]!.merge(
            newLineTotal: groupedSales[key]!.lineTotal! + sale.lineTotal!);
        groupedSales[key] = newValue;
      } else {
        groupedSales[key] = sale;
      }
    }
    final result = groupedSales.values.toList();
    return result;
  }

  bool get canCallApi {
    return context.reportArgumentModel.vendorLocations.isNotEmpty &&
        context.vendorProfileModel.displayLabel.valueOrDefault().isNotEmpty;
  }

  Future runReportAsync() async {
    if (canCallApi == false) {
      return;
    }
    await runWrappedAsync(
      () async {
        final salesListApiCaller = SalesListApiCaller();
        final results = await salesListApiCaller.getByArbitraryDatesAsync(
            dateOne: context.reportArgumentModel.dateOne,
            dateTwo: context.reportArgumentModel.dateTwo,
            vendorLocationIds: context.reportArgumentModel.vendorLocations
                .where((element) =>
                    element.id != null && element.id != Guid.defaultValue)
                .map((e) => e.id.toString())
                .toList());
        context.merge(newSales: results);
        onReportRun();
      },
    );
  }
}
