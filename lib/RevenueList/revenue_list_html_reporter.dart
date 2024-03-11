import 'package:flutter/material.dart';
import 'package:lattice_reports/ReportTemplating/report_templating.dart';
import 'package:lattice_reports/ReportTemplating/report_templating_configurator.dart';

class RevenueListHtmlReporter {
  final ReportTemplatingConfigurator reportTemplatingConfigurator;
  final String Function() getTemplatePath;

  RevenueListHtmlReporter(
      {required this.getTemplatePath,
      required this.reportTemplatingConfigurator});

  Future updateReportAsync({required AssetBundle rootBundle}) async {
    final html = await _getHtmlAsync(rootBundle);

    await reportTemplatingConfigurator.webViewControllerWrapper
        .loadHtmlStringAsync(html);
  }

  Future<String> _getHtmlAsync(AssetBundle rootBundle) async {
    final templatePath = getTemplatePath();
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
