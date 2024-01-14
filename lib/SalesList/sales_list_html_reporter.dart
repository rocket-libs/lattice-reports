import 'dart:io';

import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information_messenger.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/HtmlReporting/css_builder.dart';
import 'package:lattice_reports/HtmlReporting/html_builder.dart';
import 'package:lattice_reports/Logging/logger_wrapper.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/SalesList/Data/sales_list_api_caller.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:lattice_reports/VendorProfiles/Messaging/vendor_profile_messenger.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

class SalesListHtmlGenerator {
  final _strings = LatticeReportsConfiguration.strings;
  final Function(bool busy) onBusyStateChanged;
  final Function(String html)? onHtmlChanged;
  String _currentHtml = "";

  SalesListHtmlGenerator(
      {this.onHtmlChanged, required this.onBusyStateChanged});

  // This is only here for legacy reasons. We can't remove it as some of the older data need to be cleaned up.
  String _getPrettyLabel({required String value}) {
    final bits = value.split(".");
    try {
      Guid(bits[0]);
      return bits[1];
    } catch (e) {
      return value;
    }
  }

  Future<File?> getFileAsync() async {
    if (_currentHtml.isEmpty) {
      return null;
    }
    final Directory tempDir = _getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/lattice_reports';
    if (!Directory(tempPath).existsSync()) {
      Directory(tempPath).createSync(recursive: true);
    } else {
      _deleteFilesOlderThanOneHour(tempPath);
    }

    // Generate a unique filename using a timestamp
    final String timestamp = DateTime.now().toDDDashMMMDashYYYYHHMMSS();

    final String tempFileName = '${_strings.salesList}_$timestamp.html';

    final String tempFilePath = '$tempPath/$tempFileName';

    File file = File(tempFilePath.replaceAll(" ", "_"));
    await file.writeAsString(_currentHtml);
    return file;
  }

  _deleteFilesOlderThanOneHour(String directoryPath) {
    try {
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        return;
      }
      final files = directory.listSync();
      for (var element in files) {
        final file = File(element.path);
        final now = DateTime.now();
        final lastModified = file.lastModifiedSync();
        final difference = now.difference(lastModified);
        if (difference.inHours > 1) {
          file.deleteSync();
        }
      }
    } catch (e) {
      LoggerWrapper().e("Error deleting old files");
      LoggerWrapper().e(e);
    }
  }

  Directory _getTemporaryDirectory() {
    return Directory.systemTemp;
  }

  bool get hasHtml => _currentHtml.isNotEmpty;

  Future<List<OrderDataPointModel>> fetchAsync(
      {required ReportArgumentModel reportArgumentModel}) async {
    try {
      onBusyStateChanged(true);
      final salesListApiCaller = SalesListApiCaller();
      final results = await salesListApiCaller.getByArbitraryDatesAsync(
          dateOne: reportArgumentModel.dateOne,
          dateTwo: reportArgumentModel.dateTwo,
          vendorLocationIds: reportArgumentModel.vendorLocations
              .where((element) =>
                  element.id != null && element.id != Guid.defaultValue)
              .map((e) => e.id.toString())
              .toList());
      return results;
    } finally {
      onBusyStateChanged(false);
    }
  }

  Future<String> getHtml(
      {required ReportArgumentModel reportArgumentModel}) async {
    final cssBuilder = CssBuilder();
    final sales = await fetchAsync(reportArgumentModel: reportArgumentModel);
    await VendorProfileMessenger().refreshAsync();
    final vendorProfileModel = VendorProfileMessenger()
        .getSingleOrDefault(defaultValue: VendorProfileModel(displayLabel: ""));
    final applicationInformation =
        ApplicationInformationMessenger().applicationInformation;

    cssBuilder
        .addToClass("body", "padding: 2px;")
        .addToClass(
          ".businessName",
          "font-weight: bold; font-size: 35px; text-align:left;",
        )
        .addToClass(".reportTitle",
            "font-weight: bold; font-size: 25px; color: #4CAF50; text-align:left; margin-bottom: 20px;")
        .addToClass(
            ".footer", "font-size: 10px; text-align: center; margin-top: 20px;")
        .addToClass("table", "width: 100%; border-collapse: collapse;")
        .addToClass("table, th, td", "border: 1px solid #DFDFDF;")
        .addToClass("th, td", "padding: 5px; text-align: left;")
        .addToClass("tr:nth-child(even)", "background-color: #eee;")
        .addToClass("tr:nth-child(odd)", "background-color: #fff;")
        .addToClass("tr:hover", "background-color: #ccc;")
        .addToClass("th", "background-color: #4CAF50; color: white;")
        .addToClass(".format-number", "text-align: right;")
        .addToClass(".grand-total",
            "font-weight: bold; text-align: right; font-size: 20px;")
        .addToClass("body", "font-family: 'Roboto', sans-serif;");

    final htmlBuilder = HtmlBuilder(cssBuilder: cssBuilder)
      ..addFont(
          "<link href='https://fonts.googleapis.com/css?family=Roboto' rel='stylesheet'>")
      ..addLine(
          "<div class='businessName'>${vendorProfileModel.displayLabel}</div>")
      ..addLine("<div class='reportTitle'>${_strings.salesList}</div>")
      ..addLine("<table>")
      ..addLine("<thead>")
      ..addLine("<tr>")
      ..addLine("<th>Description</th>")
      ..addLine("<th class='format-number'>Qty</th>")
      ..addLine("<th class='format-number'>At Each</th>")
      ..addLine("<th class='format-number'>Total</th>")
      ..addLine("</tr>")
      ..addLine("</thead>")
      ..addLine("<tbody>");

    double grandTotal = 0;

    for (var element in sales) {
      final price = element.unAggregatedItemsCount.valueOrDefault() == 0
          ? 0
          : element.lineTotal.valueOrDefault() /
              element.unAggregatedItemsCount.valueOrDefault();
      htmlBuilder
          .addLine("<tr>")
          .addLine(
              "<td>${_getPrettyLabel(value: element.displayLabel.valueOrDefault())}</td>")
          .addLine(
              "<td class='format-number'>${element.unAggregatedItemsCount.formatAsCurrency(fractionDigits: 2)}</td>")
          .addLine(
              "<td class='format-number'>${price.formatAsCurrency(fractionDigits: 2)}</td>")
          .addLine(
              "<td class='format-number'>${element.lineTotal.formatAsCurrency(fractionDigits: 2)}</td>")
          .addLine("</tr>");
      grandTotal += element.lineTotal.valueOrDefault();
    }

    htmlBuilder
        .addLine("<tr>")
        .addLine(
            "<td colspan='4' class='grand-total'>${grandTotal.formatAsCurrency(fractionDigits: 2)}</td>")
        .addLine("</tr>");

    htmlBuilder.addLine("</tbody>").addLine("</table>");

    htmlBuilder
        .addLine("<div class='footer'>")
        .addLine(
            "Generated by <a href='${applicationInformation.downloadUrl}'>Lattice POS</a> on ${DateTime.now().toDDDashMMMDashYYYYHHMM()}")
        .addLine("<br><br/>${applicationInformation.downloadUrl}")
        .addLine("</div>");

    _currentHtml = htmlBuilder.build(title: _strings.salesList);
    onHtmlChanged?.call(_currentHtml);
    return _currentHtml;
  }
}
