class ApplicationInformation {
  final String applicationName;
  final String applicationVersion;
  final String buildNumber;
  final String downloadUrl;

  ApplicationInformation(
      {required this.downloadUrl,
      required this.applicationName,
      required this.applicationVersion,
      required this.buildNumber});
}
