import 'package:flutter/material.dart';
import 'package:lattice_reports/StatsCards/UI/stats_card.dart';

class DynamicDataStatsCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;
  final Color foregroundColor;
  final Color? backgroundColor;

  const DynamicDataStatsCard(
      {super.key,
      required this.header,
      required this.body,
      required this.footer,
      required this.foregroundColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return StatsCard(
        header: header,
        body: body,
        footer: footer,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor);
  }
}
