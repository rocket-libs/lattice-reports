import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lattice_reports/Blocstar/UI/widget_state.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/ReportArgumentsStrip/Data/report_arguments_strip_permissions.dart';
import 'package:lattice_reports/ReportTemplating/report_templating.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

import '../Blocstar/revenue_list_logic.dart';

class RevenueList extends StatefulWidget {
  final ReportArgumentsStripPermissions reportArgumentsStripPermissions;
  final Function(String js) runJavaScriptAsync;

  const RevenueList(
      {super.key,
      required this.reportArgumentsStripPermissions,
      required this.runJavaScriptAsync});

  @override
  State<StatefulWidget> createState() {
    return _RevenueListState();
  }
}

class _RevenueListState extends WidgetState<RevenueList, RevenueListLogic> {
  final strings = LatticeReportsConfiguration.strings;
  final _reportTemplating = ReportTemplating();
  String _html = "";
  bool _hideContent = false;
  bool _modelingData = false;

  triggerJson() async {
    if (logic.initialized == false) {
      return;
    }
    if (_modelingData) {
      return;
    }
    try {
      _modelingData = true;
      _addToWindow(value: _reportMeta, windowVar: "reportMeta");
      _addToWindow(value: await _getReportDataAsync(), windowVar: "reportData");

      await widget.runJavaScriptAsync(
        "triggerReportRunning();",
      );
    } finally {
      _modelingData = false;
    }
  }

  _addToWindow({required dynamic value, required windowVar}) async {
    final jsonObj = const JsonEncoder().convert(value);
    final js = "window.$windowVar = $jsonObj;";
    await widget.runJavaScriptAsync(js);
  }

  Future<List<Map<String, dynamic>>> _getReportDataAsync() async {
    await logic.runReportAsync();
    final results = List<Map<String, dynamic>>.empty(growable: true);

    for (var i = 0; i < logic.filteredOrders.length; i++) {
      final order = logic.filteredOrders[i];
      results.add(
        {
          "orderNumber": order.orderNumber.valueOrDefault(),
          "paidTime": order.dated.valueOrDefault().toHHMMSSAMPM(),
          "paymentMethod": order.methodOfPayment.valueOrDefault(),
          "amount":
              (order.quantity.valueOrDefault() * order.value.valueOrDefault())
                  .formatAsCurrency(fractionDigits: 2)
        },
      );
    }
    return results;
  }

  _updateWebViewAsync() async {
    _html = await _getHtmlAsync();

    await _webViewController.loadHtmlString(_html);
  }

  Map<String, String> get _reportMeta {
    return {
      "businessName":
          logic.context.vendorProfileModel.displayLabel.valueOrDefault(),
      "reportTitle": strings.revenueList,
      "appUrl": Statics.appUrl,
      "generatedAt": DateTime.now().toDDDashMMMDashYYYY(),
      "appName": Statics.appName,
    };
  }

  _exportAsync() async {
    final file = await _reportTemplating.getReportHtmlFileAsync(
      html: _html,
      fileName: "revenue_list_single_day",
    );

    await _shareAsync(file);
  }

  _shareAsync(File file) async {
    await Share.shareFiles([file.path],
        mimeTypes: ["text/html"], subject: strings.revenueList);
  }

  Future<String> _getHtmlAsync() async {
    final templatePath = "assets/reports/revenue/revenue_list_single_day.html";
    final cssPath = "assets/reports/reports.css";
    final jsPath = "assets/reports/reports.js";
    return await ReportTemplating().getReportHtmlAsync(
      templatePath: templatePath,
      assetBundle: rootBundle,
      cssPath: cssPath,
      jsPath: jsPath,
    );
  }

  @override
  Widget buildRootWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.revenueList),
        actions: [
          IconButton(
            onPressed: () {
              toggleOrientation();
            },
            icon: Icon(LookAndFeelManager.icons.orientation),
          ),
          IconButton(
            onPressed: () async {
              await _exportAsync();
            },
            icon: Icon(LookAndFeelManager.icons.export),
          ),
        ],
      ),
      body: _hideContent || logic.initialized == false
          ? Container()
          : WithProgress(
              showProgress: isBusy,
              child: ReportContainer(
                reportArgumentsStripPermissions:
                    widget.reportArgumentsStripPermissions,
                onDialogVisibilityChanged: (visible) {
                  setState(() {
                    _hideContent = visible;
                  });
                },
                canRunReport: logic.canCallApi,
                reportArgumentModel: logic.context.reportArgumentModel,
                onRunReport: () async {
                  await _updateWebViewAsync();
                },
                onReportArgumentModelChanged: (reportArgs) async {
                  logic.context.merge(newReportArgumentModel: reportArgs);
                  await _updateWebViewAsync();
                },
                body: _webViewReport,
                customArguments: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: ReportPaymentMethodPicker(
                    paymentMethods: logic.context.paymentMethods,
                    onSelectedOptionsChanged: (selectedOptions) async {
                      logic
                          .selectPaymentMethods(selectedOptions as Set<String>);
                      await _updateWebViewAsync();
                    },
                    selectedOptions: logic.context.selectedPaymentMethods,
                  ),
                ),
              ),
            ),
    );
  }
}
