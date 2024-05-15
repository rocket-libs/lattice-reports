import 'dart:collection';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInformation {
  static Future<bool> hasConnectionAsync() async {
    final connectivityResults = await Connectivity().checkConnectivity();

    final hasConnection = isConnectedState(connectivityResults);
    return hasConnection;
  }

  static bool isConnectedState(List<ConnectivityResult> connectivityResults) {
    final connectedStates = HashSet<ConnectivityResult>()
      ..add(ConnectivityResult.mobile)
      ..add(ConnectivityResult.wifi)
      ..add(ConnectivityResult.ethernet);
    final isConnected = connectivityResults.any((candidate) {
      return connectedStates.contains(candidate);
    });
    return isConnected;
  }
}
