import 'package:flutter/material.dart';
import 'package:lattice_reports/WebviewHelpers/navigation_delegate_wrapper.dart';

class WebViewControllerWrapper {
  final Function setJavaScriptModeUnRestricted;
  final Function(Color color) setBackgroundColor;
  final Function(String name,
      {required void Function(dynamic) onMessageReceived}) addJavaScriptChannel;
  final Function(NavigationDelegateWrapper delegate) setNavigationDelegate;
  final Function(String javaScript) runJavaScriptAsync;
  final Function(String html) loadHtmlStringAsync;

  WebViewControllerWrapper(
      {required this.loadHtmlStringAsync,
      required this.runJavaScriptAsync,
      required this.setNavigationDelegate,
      required this.setJavaScriptModeUnRestricted,
      required this.setBackgroundColor,
      required this.addJavaScriptChannel});
}
