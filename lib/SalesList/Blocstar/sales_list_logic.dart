import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';

import '../../../Blocstar/logic_base.dart';
import '../Data/sales_list_api_caller.dart';
import 'sales_list_context.dart';

class SalesListLogic extends LogicBase<SalesListContext> {
  @override
  Future initializeAsync() async {
    final currentVendorLocation =
        AuthenticationMessenger().currentVendorLocation;
    context = SalesListContext(
      this,
      userProfileId: Guid.defaultValue,
      sales: [],
      reportArgumentModel: ReportArgumentModel(
        dateOne: DateTime.now(),
        dateTwo: DateTime.now(),
        vendorLocations:
            currentVendorLocation != null ? [currentVendorLocation] : [],
      ),
    );
    await super.initializeAsync();
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
    return context.reportArgumentModel.vendorLocations.isNotEmpty;
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
      },
    );
  }
}
