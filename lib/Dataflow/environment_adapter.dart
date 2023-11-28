import 'environment_information.dart';

class EnvironmentAdapter {
  final EnvironmentInformation development;
  final EnvironmentInformation production;
  final Future<Map<String, String>> Function(Map<String, String> requestHeaders)
      appendHeadersAsync;

  EnvironmentAdapter(
      {required this.appendHeadersAsync,
      required this.development,
      required this.production});
}
