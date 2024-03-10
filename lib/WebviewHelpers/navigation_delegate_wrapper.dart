import 'dart:async';

class NavigationDelegateWrapper {
  final void Function(String url)? onPageFinished;
  final FutureOr<dynamic> Function(dynamic request)? onNavigationRequest;

  NavigationDelegateWrapper(
      {this.onNavigationRequest, required this.onPageFinished});
}
