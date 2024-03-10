import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information_messenger.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:lattice_reports/VendorProfiles/Messaging/vendor_profile_messenger.dart';
import 'package:lattice_reports/WebviewHelpers/navigation_delegate_wrapper.dart';
import 'package:lattice_reports/WebviewHelpers/web_view_controller_wrapper.dart';

class ReportTemplatingConfigurator {
  final WebViewControllerWrapper webViewControllerWrapper;
  final _jsChannel = "flutter";
  final bool Function() webViewReadyToTriggerJson;
  final String reportTitle;
  final Function() runReportAsync;
  final List<List<OrderDataPointModel>> Function() getFilteredData;
  final Map<String, dynamic> Function<T>(T item) convertItemToMap;

  bool _modelingData = false;

  Map<String, String> get _reportMeta {
    final appInfo = ApplicationInformationMessenger().applicationInformation;
    return {
      "businessName": VendorProfileMessenger()
          .getSingleOrDefault(defaultValue: VendorProfileModel())
          .displayLabel
          .valueOrDefault(),
      "reportTitle": reportTitle,
      "appUrl": appInfo.downloadUrl,
      "generatedAt": DateTime.now().toDDDashMMMDashYYYY(),
      "appName": appInfo.applicationName,
    };
  }

  ReportTemplatingConfigurator(
      {required this.convertItemToMap,
      required this.runReportAsync,
      required this.getFilteredData,
      required this.reportTitle,
      required this.webViewReadyToTriggerJson,
      required this.webViewControllerWrapper}) {
    webViewControllerWrapper
      ..setJavaScriptModeUnRestricted()
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(_jsChannel, onMessageReceived: (_) {})
      ..setNavigationDelegate(
        NavigationDelegateWrapper(
          onPageFinished: (url) {
            _triggerJson();
          },
        ),
      );
  }

  _triggerJson() async {
    if (webViewReadyToTriggerJson() == false) {
      return;
    }
    if (_modelingData) {
      return;
    }
    try {
      _modelingData = true;
      _addToWindow(value: _reportMeta, windowVar: "reportMeta");
      _addToWindow(value: await _getReportDataAsync(), windowVar: "reportData");

      await webViewControllerWrapper.runJavaScriptAsync(
        "triggerReportRunning();",
      );
    } finally {
      _modelingData = false;
    }
  }

  _addToWindow({required dynamic value, required windowVar}) async {
    final jsonObj = const JsonEncoder().convert(value);
    final js = "window.$windowVar = $jsonObj;";
    await webViewControllerWrapper.runJavaScriptAsync(js);
  }

  Future<List<Map<String, dynamic>>> _getReportDataAsync() async {
    await runReportAsync();
    final results = List<Map<String, dynamic>>.empty(growable: true);

    final filteredData = getFilteredData();
    for (var i = 0; i < filteredData.length; i++) {
      final item = filteredData[i];
      final map = convertItemToMap(item);
      results.add(map);
    }
    return results;
  }
}
