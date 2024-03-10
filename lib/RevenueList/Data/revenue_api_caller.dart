import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/Dataflow/endpoint_caller.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:preflection/Serializer.dart';

class RevenueApiCaller {
  Future<List<OrderDataPointModel>> getByArbitraryDatesWithModelAsync(
      {required ReportArgumentModel reportArgumentModel,
      bool aggregateSingleDayData = false}) async {
    return await _getByArbitraryDatesAsync(
        dateOne: reportArgumentModel.dateOne,
        dateTwo: reportArgumentModel.dateTwo,
        vendorLocationIds: reportArgumentModel.vendorLocations
            .map((e) => e.id.valueOrDefault().toString())
            .toList());
  }

  Future<List<OrderDataPointModel>> _getByArbitraryDatesAsync(
      {required dateOne,
      required dateTwo,
      List<String>? vendorLocationIds,
      bool aggregateSingleDayData = false}) async {
    final endpointCaller = EndpointCaller.lattice();
    final dateOneString = (dateOne as DateTime?).toYYYYDashMMDashDD();
    final datetTwoString = (dateTwo as DateTime?).toYYYYDashMMDashDD();

    final vendorLocationIdsQuery = vendorLocationIds.toNonNullList().isNotEmpty
        ? "&vendorLocationIds=${vendorLocationIds?.toList().join("&vendorLocationIds=")}"
        : "";

    final singleDayDataAggregateQuery =
        aggregateSingleDayData ? "&aggregateSingleDayData=true" : "";
    final response = await endpointCaller.getAsync<List<dynamic>>(
        "v1/Revenues/get-revenues-by-arbitrary-dates?dateOne=$dateOneString&dateTwo=$datetTwoString$vendorLocationIdsQuery$singleDayDataAggregateQuery");

    final result = Serializer.deserializeMany<OrderDataPointModel>(response);
    return result.toNonNullList();
  }
}
