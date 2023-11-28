import 'dart:collection';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInformation {
  static Future<bool> hasConnectionAsync() async {
    final connectivityState = await Connectivity().checkConnectivity();
    final hasConnection = isConnectedState(connectivityState);
    return hasConnection;
  }

  static bool isConnectedState(ConnectivityResult connectivityState) {
    final connectedStates = HashSet<ConnectivityResult>()
      ..add(ConnectivityResult.mobile)
      ..add(ConnectivityResult.wifi)
      ..add(ConnectivityResult.ethernet);
    final isConnectedState =
        connectedStates.any((element) => element == connectivityState);
    return isConnectedState;
  }
}
