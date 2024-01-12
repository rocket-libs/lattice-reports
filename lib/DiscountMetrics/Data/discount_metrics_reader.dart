import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Dataflow/endpoint_caller.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';

class DiscountMetricsReader {
  String get _apiBaseRoute => "v1/OrderHeaderDiscounts/";
  Future<List<OrderDataPointModel>> getByArbitraryDates(
      {bool? fetchFromRemote,
      required DateTime dateOne,
      DateTime? dateTwo,
      required List<Guid> storeIds,
      required bool aggregateSingleDayData}) async {
    dateTwo ??= dateOne;
    final vendorLocationIdsSet =
        storeIds.map((e) => e.value.valueOrDefault()).toSet();
    final apiCaller = EndpointCaller.lattice();
    final result = await apiCaller.getAsync(
        '${_apiBaseRoute}get-discounts-by-arbitrary-dates?dateOne=${dateOne.toIso8601String()}&dateTwo=${dateTwo.toIso8601String()}&vendorLocationIds=${vendorLocationIdsSet.join(',')}&aggregateSingleDayData=$aggregateSingleDayData',
        offlineDisplayLabel: null);
    return result;
  }
}
