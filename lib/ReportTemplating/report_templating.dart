import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lattice_reports/DateFormatting/custom_date_formatting.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

class ReportTemplating {
  Future<String> getReportHtmlAsync({
    required String templatePath,
    required AssetBundle assetBundle,
    String? cssPath,
    cssPlaceholder = "/* report-css-placeholder */",
    String? jsPath,
    jsPlaceholder = "/* report-js-placeholder */",
  }) async {
    String template = await assetBundle.loadString(templatePath);
    template = await _injectCss(
        template: template,
        assetBundle: assetBundle,
        cssPath: cssPath,
        cssPlaceholder: cssPlaceholder);
    template = await _injectJs(
        template: template,
        assetBundle: assetBundle,
        jsPath: jsPath,
        jsPlaceholder: jsPlaceholder);
    return template;
  }

  Future<File> getReportHtmlFileAsync({
    required String html,
    required String fileName,
  }) async {
    return await _saveToFileAsync(html: html, fileName: fileName);
  }

  String _getHtmlColorCode({required Color flutterColor}) {
    int red = flutterColor.red;
    int green = flutterColor.green;
    int blue = flutterColor.blue;

    // Converting the values to hexadecimal
    String hexRed = red.toRadixString(16).padLeft(2, '0');
    String hexGreen = green.toRadixString(16).padLeft(2, '0');
    String hexBlue = blue.toRadixString(16).padLeft(2, '0');

    // Combining the hexadecimal values to get the HTML color code
    String htmlColorCode = '#$hexRed$hexGreen$hexBlue';
    return htmlColorCode;
  }

  Future<String> _injectCss(
      {required String template,
      required AssetBundle assetBundle,
      String? cssPath,
      required String cssPlaceholder}) async {
    if (cssPath != null) {
      final css = await assetBundle.loadString(cssPath);
      final primaryColor = _getHtmlColorCode(
          flutterColor: LatticeReportsConfiguration.theming.primaryColor);
      css.replaceAllMapped(RegExp(r'--primary-color\s*:\s*#000\s*;'),
          (match) => '--primary-color: #$primaryColor;');
      template = template.replaceAll(cssPlaceholder, css);
    }
    return template;
  }

  Future<String> _injectJs(
      {required String template,
      required AssetBundle assetBundle,
      String? jsPath,
      required String jsPlaceholder}) async {
    if (jsPath != null) {
      final js = await assetBundle.loadString(jsPath);
      template = template.replaceAll(jsPlaceholder, js);
    }
    return template;
  }

  Future<Directory> _getTemporaryDirectoryAsync() async {
    Directory tempDir = await Directory.systemTemp.createTemp();
    return tempDir;
  }

  Future<File> _saveToFileAsync(
      {required String html, required String fileName}) async {
    final Directory tempDir = await _getTemporaryDirectoryAsync();
    final String tempPath = "${tempDir.path}/lattice_pos/reports";
    if (!Directory(tempPath).existsSync()) {
      Directory(tempPath).createSync(recursive: true);
    } else {
      _deleteFilesOlderThanOneHour(tempPath);
    }

    // Generate a unique filename using a timestamp
    final String timestamp =
        CustomDateFormat('dd_MMM_yy_HH_mm_ss').format(DateTime.now());
    final String tempFileName = '${fileName}_$timestamp.html';

    final String tempFilePath = '$tempPath/$tempFileName';

    File file = File(tempFilePath.replaceAll(" ", "_"));
    await file.writeAsString(html);
    return file;
  }

  _deleteFilesOlderThanOneHour(String directoryPath) {
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
  }
}
