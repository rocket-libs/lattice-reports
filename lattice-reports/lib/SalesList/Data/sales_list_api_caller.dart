import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Dataflow/endpoint_caller.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:preflection/Serializer.dart';

//https://pub.dev/packages/fl_chart
class SalesListApiCaller {
  Future<List<OrderDataPointModel>> getByArbitraryDatesAsync(
      {required dateOne,
      required dateTwo,
      List<String>? vendorLocationIds}) async {
    final endpointCaller = EndpointCaller.lattice();
    final dateOneString = (dateOne as DateTime?).toDDDashMMMDashYYYY();
    final datetTwoString = (dateTwo as DateTime?).toYYYYDashMMDashDD();

    final vendorLocationIdsQuery = vendorLocationIds.toNonNullList().isNotEmpty
        ? "&vendorLocationIds=${vendorLocationIds?.toList().join("&vendorLocationIds=")}"
        : "";
    final response = await endpointCaller.getAsync<List<dynamic>>(
        "v1/OrderDataPoints/get-sales-by-arbitrary-dates?dateOne=$dateOneString&dateTwo=$datetTwoString$vendorLocationIdsQuery");

    final result = Serializer.deserializeMany<OrderDataPointModel>(response);
    return result.toNonNullList();
  }
}
