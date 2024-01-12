import 'package:blocstar/BlocstarContextBase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/QuickOverview/Data/two_period_order_data_points.dart';

class QuickOverviewContext extends BlocstarContextBase<QuickOverviewContext> {
  final TwoPeriodOrderDataPoints orderDataPoints;
  final TwoPeriodOrderDataPoints revenueDataPoints;
  final TwoPeriodOrderDataPoints discountDataPoints;
  final ReportArgumentModel reportArgumentModel;
  final Guid userProfileId;

  QuickOverviewContext(super.logic,
      {required this.revenueDataPoints,
      required this.discountDataPoints,
      required this.reportArgumentModel,
      required this.orderDataPoints,
      required this.userProfileId});

  @override
  merge({
    Guid? newUserProfileId,
    TwoPeriodOrderDataPoints? newOrderDataPoints,
    ReportArgumentModel? newReportArgumentModel,
    TwoPeriodOrderDataPoints? newRevenueDataPoints,
    TwoPeriodOrderDataPoints? newDiscountDataPoints,
  }) {
    return QuickOverviewContext(
      logic,
      userProfileId: newUserProfileId ?? userProfileId,
      orderDataPoints: newOrderDataPoints ?? orderDataPoints,
      reportArgumentModel: newReportArgumentModel ?? reportArgumentModel,
      revenueDataPoints: newRevenueDataPoints ?? revenueDataPoints,
      discountDataPoints: newDiscountDataPoints ?? discountDataPoints,
    );
  }
}
