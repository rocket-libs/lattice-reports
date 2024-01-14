import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Dataflow/endpoint_caller.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:preflection/Serializer.dart';

class RevenuesReader {
  String get apiBaseRoute => "v1/Revenues/";
  Future<List<OrderDataPointModel>> getByArbitraryDates(
      {required DateTime dateOne,
      DateTime? dateTwo,
      required List<Guid> storeIds,
      required bool aggregateSingleDayData}) async {
    dateTwo ??= dateOne;
    final vendorLocationIdsSet =
        storeIds.map((e) => e.value.valueOrDefault()).toSet();
    final apiCaller = EndpointCaller.lattice();
    final response = await apiCaller.getAsync<List<dynamic>>(
        '${apiBaseRoute}get-revenues-by-arbitrary-dates?dateOne=${dateOne.toIso8601String()}&dateTwo=${dateTwo.toIso8601String()}&vendorLocationIds=${vendorLocationIdsSet.join(',')}&aggregateSingleDayData=$aggregateSingleDayData',
        offlineDisplayLabel: null);
    final result = Serializer.deserializeMany<OrderDataPointModel>(response);
    return result.toNonNullList();
  }
}
