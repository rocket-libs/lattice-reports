class OfflineResponse {
  final int statusCode;
  final String body;
  static const String offlineSuccess = "offline-success";

  OfflineResponse(this.statusCode, this.body);
}
