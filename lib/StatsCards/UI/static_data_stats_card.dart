import 'package:flutter/widgets.dart';
import 'package:lattice_reports/StatsCards/UI/stats_card.dart';

class StaticDataStatsCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Color foregroundColor;
  final Color? backgroundColor;

  const StaticDataStatsCard(
      {super.key,
      required this.header,
      required this.body,
      required this.foregroundColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return StatsCard(
        header: header,
        body: body,
        footer: Container(),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor);
  }
}
