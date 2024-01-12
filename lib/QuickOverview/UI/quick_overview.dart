import 'package:flutter/material.dart';
import 'package:lattice_reports/Blocstar/UI/widget_state.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/QuickOverview/UI/quick_overview_stat_card.dart';
import 'package:lattice_reports/ReportArgumentsStrip/Data/report_arguments_strip_permissions.dart';
import 'package:lattice_reports/ReportContainer/UI/report_container.dart';
import 'package:lattice_reports/StatsCards/Styles/stats_card_default_styles.dart';
import 'package:lattice_reports/StatsCards/UI/static_data_stats_card.dart';

import 'package:lattice_reports/WithProgress/UI/with_progress.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

import '../Blocstar/quick_overview_logic.dart';

class QuickOverview extends StatefulWidget {
  const QuickOverview({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuickOverviewState();
  }
}

class _QuickOverviewState
    extends WidgetState<QuickOverview, QuickOverviewLogic> {
  final strings = LatticeReportsConfiguration.strings;

  List<Widget> get _customerStats {
    return [
      StaticDataStatsCard(
        header: Text(
          strings.customers,
          style: StatsCardDefaultStyles.headerTextStyle(color: Colors.blue),
        ),
        body: Text(
          logic.overviewForToday.customers.toString(),
          style: StatsCardDefaultStyles.bodyTextStyle(color: Colors.blue),
        ),
        foregroundColor: Colors.blue,
      ),
      OverviewStatCard(
        stat: logic.customersStat,
        headerText: strings.customersTodayVsYesterday,
        bodyText: logic.customersStat.difference.toInt().signed(),
      ),
    ];
  }

  List<Widget> get _orderStats {
    return [
      StaticDataStatsCard(
        header: Text(
          strings.orders,
          style: StatsCardDefaultStyles.headerTextStyle(color: Colors.blue),
        ),
        body: Text(
          logic.overviewForToday.orders.toString(),
          style: StatsCardDefaultStyles.bodyTextStyle(color: Colors.blue),
        ),
        foregroundColor: Colors.blue,
      ),
      OverviewStatCard(
          headerText: strings.ordersTodayVsYesterday,
          bodyText: logic.ordersStat.difference.signed(),
          stat: logic.ordersStat)
    ];
  }

  List<Widget> get _revenueStats {
    return [
      StaticDataStatsCard(
        header: Text(
          strings.revenue,
          style: StatsCardDefaultStyles.headerTextStyle(color: Colors.blue),
        ),
        body: Text(
          logic.overviewForToday.revenue.formatAsCurrency(fractionDigits: 2),
          style: StatsCardDefaultStyles.bodyTextStyle(color: Colors.blue),
        ),
        foregroundColor: Colors.blue,
      ),
      OverviewStatCard(
          headerText: strings.revenueTodayVsYesterday,
          bodyText: logic.revenueStat.difference
              .formatAsCurrency(fractionDigits: 2, includePositiveSign: true),
          stat: logic.revenueStat)
    ];
  }

  List<Widget> get _salesStats {
    return [
      StaticDataStatsCard(
        header: Text(
          strings.sales,
          style: StatsCardDefaultStyles.headerTextStyle(color: Colors.blue),
        ),
        body: Text(
          logic.overviewForToday.sales.formatAsCurrency(fractionDigits: 2),
          style: StatsCardDefaultStyles.bodyTextStyle(color: Colors.blue),
        ),
        foregroundColor: Colors.blue,
      ),
      OverviewStatCard(
          headerText: strings.salesTodayVsYesterday,
          bodyText: logic.salesStat.difference
              .formatAsCurrency(fractionDigits: 2, includePositiveSign: true),
          stat: logic.salesStat)
    ];
  }

  List<Widget> get _discountStats {
    return [
      StaticDataStatsCard(
        header: Text(
          strings.discounts,
          style: StatsCardDefaultStyles.headerTextStyle(color: Colors.blue),
        ),
        body: Text(
          logic.overviewForToday.discounts.formatAsCurrency(fractionDigits: 2),
          style: StatsCardDefaultStyles.bodyTextStyle(color: Colors.blue),
        ),
        foregroundColor: Colors.blue,
      ),
      OverviewStatCard(
          headerText: strings.discountsTodayVsYesterday,
          bodyText: logic.discountsStat.difference
              .formatAsCurrency(fractionDigits: 2, includePositiveSign: true),
          stat: logic.discountsStat)
    ];
  }

  bool get _isLargeScreen {
    return MediaQuery.of(context).size.width > 600;
  }

  @override
  Widget buildRootWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.quickOverview),
      ),
      body: WithProgress(
        showProgress: isBusy,
        child: ReportContainer(
            canRunReport: logic.canRunReport,
            onDialogVisibilityChanged: (visible) {},
            onReportArgumentModelChanged: (reportArgs) {
              logic.context.merge(newReportArgumentModel: reportArgs);
            },
            onRunReport: () async {
              await logic.fetchOrderDataPointsAsync();
            },
            reportArgumentModel: logic.context.reportArgumentModel,
            reportArgumentsStripPermissions: ReportArgumentsStripPermissions(
              canChangeDateRange: () => Future.value(false),
              canChangeVendorLocations: () => Future.value(true),
            ),
            body: GridView.count(
              crossAxisCount: _isLargeScreen ? 4 : 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: [
                ..._customerStats,
                ..._revenueStats,
                ..._salesStats,
                ..._orderStats,
                ..._discountStats
              ],
            )),
      ),
    );
  }
}
