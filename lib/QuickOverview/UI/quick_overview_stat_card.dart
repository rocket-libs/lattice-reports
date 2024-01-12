import 'package:flutter/material.dart';
import 'package:lattice_reports/QuickOverview/Data/stat.dart';
import 'package:lattice_reports/StatsCards/Styles/stats_card_default_styles.dart';
import 'package:lattice_reports/StatsCards/UI/dynamic_data_stats_card.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

class OverviewStatCard extends StatelessWidget {
  final String headerText;
  final String bodyText;
  final Stat stat;
  final strings = LatticeReportsConfiguration.strings;
  OverviewStatCard(
      {super.key,
      required this.headerText,
      required this.bodyText,
      required this.stat});
  @override
  Widget build(BuildContext context) {
    final foregroundColor = _getColorFromStatus(stat: stat);
    return DynamicDataStatsCard(
      header: Text(headerText,
          style: StatsCardDefaultStyles.headerTextStyle(color: foregroundColor),
          textAlign: TextAlign.center),
      body: Text(
        bodyText,
        style: StatsCardDefaultStyles.bodyTextStyle(color: foregroundColor),
      ),
      footer: Text(
        _getFooterTextFromStat(stat: stat),
        style: StatsCardDefaultStyles.footerTextStyle(color: foregroundColor),
        textAlign: TextAlign.center,
      ),
      foregroundColor: foregroundColor,
    );
  }

  Color _getColorFromStatus({required Stat stat}) {
    if (stat.isNegative) {
      return Colors.red;
    } else if (stat.isPositive) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  String _getFooterTextFromStat({required Stat stat}) {
    if (stat.isNegative) {
      return strings.less;
    } else if (stat.isPositive) {
      return strings.more;
    } else {
      return strings.same;
    }
  }
}
