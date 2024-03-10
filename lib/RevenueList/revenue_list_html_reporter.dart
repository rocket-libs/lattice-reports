import 'package:flutter/material.dart';
import 'package:lattice_reports/ReportTemplating/report_templating.dart';
import 'package:lattice_reports/ReportTemplating/report_templating_configurator.dart';

class RevenueListHtmlReporter {
  final ReportTemplatingConfigurator reportTemplatingConfigurator;

  RevenueListHtmlReporter({required this.reportTemplatingConfigurator});

  Future updateReportAsync({required AssetBundle rootBundle}) async {
    final html = await _getHtmlAsync(rootBundle);

    await reportTemplatingConfigurator.webViewControllerWrapper
        .loadHtmlStringAsync(html);
  }

  Future<String> _getHtmlAsync(AssetBundle rootBundle) async {
    const templatePath = "assets/reports/revenue/revenue_list_single_day.html";
    const cssPath = "assets/reports/reports.css";
    const jsPath = "assets/reports/reports.js";
    return await ReportTemplating().getReportHtmlAsync(
      templatePath: templatePath,
      assetBundle: rootBundle,
      cssPath: cssPath,
      jsPath: jsPath,
    );
  }
}
