import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Blocstar/logic_base.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/DiscountMetrics/Data/discount_metrics_reader.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/QuickOverview/Blocstar/quick_overview_context.dart';
import 'package:lattice_reports/QuickOverview/Data/stat.dart';
import 'package:lattice_reports/QuickOverview/Data/two_period_order_data_points.dart';
import 'package:lattice_reports/QuickOverview/Data/quick_overview_for_day.dart';
import 'package:lattice_reports/Revenues/Data/revenues_reader.dart';
import 'package:lattice_reports/SalesList/Data/sales_list_api_caller.dart';

class QuickOverviewLogic extends LogicBase<QuickOverviewContext> {
  @override
  Future initializeAsync() async {
    final userProfileId =
        AuthenticationMessenger().authenticationInformation.userProfileId;
    context = QuickOverviewContext(this,
        userProfileId: userProfileId,
        orderDataPoints: TwoPeriodOrderDataPoints(),
        revenueDataPoints: TwoPeriodOrderDataPoints(),
        discountDataPoints: TwoPeriodOrderDataPoints(),
        reportArgumentModel: ReportArgumentModel(
          dateOne: DateTime.now(),
          dateTwo: DateTime.now(),
          vendorLocations: [],
        ));
    await super.initializeAsync();
  }

  bool get canRunReport {
    return context.reportArgumentModel.vendorLocations.isNotEmpty;
  }

  Future fetchOrderDataPointsAsync() async {
    if (!canRunReport) return;
    await runWrappedAsync(() async {
      await Future.wait([
        _fetchCurrentDataPointsAsync(),
        _fetchPreviousDataPointsAsync(),
        _fetchCurrentRevenueDataPointsAsync(),
        _fetchPreviousRevenueDataPointsAsync(),
        _fetchCurrentDiscountDataPointsAsync(),
        _fetchPreviousDiscountDataPointsAsync(),
      ]);
    });
  }

  Stat get customersStat {
    return Stat(
      current: overviewForToday.customers * 1.0,
      previous: overviewForYesterday.customers * 1.0,
    );
  }

  Stat get ordersStat {
    return Stat(
      current: overviewForToday.orders * 1.0,
      previous: overviewForYesterday.orders * 1.0,
    );
  }

  Stat get salesStat {
    return Stat(
      current: overviewForToday.sales,
      previous: overviewForYesterday.sales,
    );
  }

  Stat get revenueStat {
    return Stat(
      current: overviewForToday.revenue,
      previous: overviewForYesterday.revenue,
    );
  }

  Stat get discountsStat {
    return Stat(
      current: overviewForToday.discounts,
      previous: overviewForYesterday.discounts,
    );
  }

  QuickOverviewForDay get overviewForToday {
    return _getOverview(
      orders: context.orderDataPoints.newerDataPoints,
      revenue: context.revenueDataPoints.newerDataPoints,
      discounts: context.discountDataPoints.newerDataPoints,
    );
  }

  QuickOverviewForDay get overviewForYesterday {
    return _getOverview(
      orders: context.orderDataPoints.olderDataPoints,
      revenue: context.revenueDataPoints.olderDataPoints,
      discounts: context.discountDataPoints.olderDataPoints,
    );
  }

  Future _fetchCurrentDataPointsAsync() async {
    final salesListApiCaller = SalesListApiCaller();
    context.orderDataPoints.newerDataPoints =
        await salesListApiCaller.getByArbitraryDatesWithModelAsync(
            reportArgumentModel: context.reportArgumentModel);
  }

  Future _fetchPreviousDataPointsAsync() async {
    final salesListApiCaller = SalesListApiCaller();
    context.orderDataPoints.olderDataPoints =
        await salesListApiCaller.getByArbitraryDatesWithModelAsync(
            reportArgumentModel:
                context.reportArgumentModel.previousPeriodModel);
  }

  Future _fetchCurrentRevenueDataPointsAsync() async {
    context.revenueDataPoints.newerDataPoints =
        await _fetchDayRevenueData(context.reportArgumentModel.dateOne);
  }

  Future _fetchPreviousRevenueDataPointsAsync() async {
    context.revenueDataPoints.olderDataPoints = await _fetchDayRevenueData(
        context.reportArgumentModel.previousPeriodModel.dateOne);
  }

  Future _fetchCurrentDiscountDataPointsAsync() async {
    context.discountDataPoints.newerDataPoints =
        await _fetchDayDiscountData(context.reportArgumentModel.dateOne);
  }

  Future _fetchPreviousDiscountDataPointsAsync() async {
    context.discountDataPoints.olderDataPoints = await _fetchDayDiscountData(
        context.reportArgumentModel.previousPeriodModel.dateOne);
  }

  Future<List<OrderDataPointModel>> _fetchDayRevenueData(DateTime day) async {
    if (_hasSelectedStores == false) {
      return [];
    }
    final metricsReader = RevenuesReader();
    final dataPoints = await metricsReader.getByArbitraryDates(
      dateOne: day,
      dateTwo: day,
      aggregateSingleDayData: true,
      storeIds: context.reportArgumentModel.vendorLocations
          .map((e) => e.id.valueOrDefault())
          .toList(),
    );
    return dataPoints;
  }

  Future<List<OrderDataPointModel>> _fetchDayDiscountData(DateTime day) async {
    if (_hasSelectedStores == false) {
      return [];
    }
    final metricsReader = DiscountMetricsReader();
    final dataPoints = await metricsReader.getByArbitraryDates(
      fetchFromRemote: true,
      dateOne: day,
      dateTwo: day,
      aggregateSingleDayData: true,
      storeIds: context.reportArgumentModel.vendorLocations
          .map((e) => e.id.valueOrDefault())
          .toList(),
    );
    return dataPoints;
  }

  bool get _hasSelectedStores {
    return context.reportArgumentModel.vendorLocations.isNotEmpty;
  }

  QuickOverviewForDay _getOverview(
      {required List<OrderDataPointModel> orders,
      required List<OrderDataPointModel> revenue,
      required List<OrderDataPointModel> discounts}) {
    if (orders.isEmpty) {
      return QuickOverviewForDay(
          sales: 0, orders: 0, revenue: 0, discounts: 0, customers: 0);
    } else {
      final sumOfLineTotals = orders.isEmpty
          ? 0.0
          : orders
              .map(
              (e) => e.lineTotal,
            )
              .reduce(
              (value, element) {
                return value.valueOrDefault() + element.valueOrDefault();
              },
            ).valueOrDefault();

      final sumOfRevenue = revenue.isEmpty
          ? 0.0
          : revenue
              .map(
              (e) => e.value,
            )
              .reduce(
              (value, element) {
                return value.valueOrDefault() + element.valueOrDefault();
              },
            ).valueOrDefault();

      final sumOfDiscounts = discounts.isEmpty
          ? 0.0
          : discounts
              .map(
              (e) => e.value,
            )
              .reduce(
              (value, element) {
                return value.valueOrDefault() + element.valueOrDefault();
              },
            ).valueOrDefault();

      return QuickOverviewForDay(
        sales: sumOfLineTotals,
        orders: _getUniqueOrdersCount(dataset: orders),
        revenue: sumOfRevenue,
        discounts: sumOfDiscounts,
        customers: _getUniqueCustomerCount(dataset: orders),
      );
    }
  }

  _getUniqueOrdersCount({required List<OrderDataPointModel> dataset}) {
    var count = 0;
    for (var item in dataset) {
      count += item.unAggregatedItemsCount.valueOrDefault();
    }
    return count;
  }

  _getUniqueCustomerCount({required List<OrderDataPointModel> dataset}) {
    final idsSet = dataset.map((e) => e.phoneNumber.valueOrDefault()).toSet();
    return idsSet.length;
  }

  @override
  Future runReportAsync() {
    // TODO: implement runReportAsync
    throw UnimplementedError();
  }
}
