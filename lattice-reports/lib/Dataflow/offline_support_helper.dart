import 'http_methods_enum.dart';

class OfflineSupportHelper {
  Future writeAsync(
      {required String relativeUrl,
      Map? payload,
      required HttpMethodsEnum method,
      required String offlineDisplayLabel}) async {
    throw Exception("Offline support not yet added");
  }
}
