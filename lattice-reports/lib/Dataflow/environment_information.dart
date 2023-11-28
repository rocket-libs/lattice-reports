class EnvironmentInformation {
  final String host;
  final int apiPort;
  final int webUiPort;
  final String scheme;

  const EnvironmentInformation(
      {required this.host,
      required this.apiPort,
      required this.webUiPort,
      required this.scheme});
}
