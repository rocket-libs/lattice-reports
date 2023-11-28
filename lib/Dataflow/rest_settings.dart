import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Dataflow/environment_adapter.dart';
import 'package:lattice_reports/Dataflow/environment_information.dart';
import 'package:lattice_reports/Dataflow/micro_service_enum.dart';
import 'package:lattice_reports/Dataflow/rest_exception.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

class RestSettings {
  static const String development = "Development";
  static const String production = "Production";
  static const String productionHost = "lattice.ninja";

  static const String environment = production;
  static bool get isProduction => environment == production;
  static bool get isDevelopment => !isProduction;

  static bool get mockOffline {
    if (isProduction) {
      return false;
    } else {
      return true;
    }
  }

  static String getEndpoint(
      {required String relativeUrl,
      required MicroServiceEnum targetMicroService,
      required bool includeStoreId}) {
    final backendUrl =
        _backendUrl(targetMicroService, includeStoreId: includeStoreId);
    return '$backendUrl$relativeUrl';
  }

  static String _backendUrl(MicroServiceEnum targetMicroService,
      {required bool includeStoreId}) {
    final environmentInformation = _getEnvironmentInformation(
        targetMicroService,
        includeStoreId: includeStoreId);
    final webBaseUrl =
        _getWebBaseUrl(targetMicroService, includeStoreId: includeStoreId);
    final url = '$webBaseUrl:${environmentInformation.apiPort}/api/';
    return url;
  }

  static String _getWebBaseUrl(MicroServiceEnum targetMicroService,
      {required bool includeStoreId}) {
    final environmentInformation = _getEnvironmentInformation(
        targetMicroService,
        includeStoreId: includeStoreId);
    final url =
        '${environmentInformation.scheme}://${environmentInformation.host}';
    return url;
  }

  static String getwebUIBaseUrl(MicroServiceEnum targetMicroService,
      {required bool includeStoreId}) {
    final environmentInformation = _getEnvironmentInformation(
        targetMicroService,
        includeStoreId: includeStoreId);
    final url = "$_getWebBaseUrl:${environmentInformation.webUiPort}/";
    return url;
  }

  static int get standardAsyncTimeout => environment == production ? 45 : 45;

  static _appendHeadersAsync(Map<String, String> requestHeaders,
      {required bool includeStoreId}) async {
    final authenticationInformation =
        AuthenticationMessenger().authenticationInformation;

    requestHeaders.addAll({
      'X-User-Session-Id': authenticationInformation.userSessionId.value,
      "X-App-Type": "mobile",
      "X-User-Session-Type": "vendor",
      "X-User-Session-Profile-Id":
          authenticationInformation.userProfileId.value,
      "X-Vendor-Location-Id": includeStoreId
          ? authenticationInformation.vendorLocationId.value
          : "",
    });
    return requestHeaders;
  }

  static EnvironmentAdapter getEnvironmentAdapter(
      MicroServiceEnum targetMicroService,
      {required bool includeStoreId}) {
    final Map<MicroServiceEnum, EnvironmentAdapter> environentsLookup = {
      MicroServiceEnum.lattice: EnvironmentAdapter(
        development: LatticeReportsConfiguration.environmentInformation!,
        production: LatticeReportsConfiguration.environmentInformation!,
        appendHeadersAsync: (requestHeaders) async {
          return await _appendHeadersAsync(requestHeaders,
              includeStoreId: includeStoreId);
        },
      )
    };

    final environmentAdapter = environentsLookup[targetMicroService];
    if (environmentAdapter == null) {
      throw RestException(
          message: "Unknown microservice '$targetMicroService' targeted");
    }
    return environmentAdapter;
  }

  static EnvironmentInformation _getEnvironmentInformation(
      MicroServiceEnum targetMicroService,
      {required bool includeStoreId}) {
    final environmentAdapter = getEnvironmentAdapter(targetMicroService,
        includeStoreId: includeStoreId);
    switch (environment) {
      case development:
        return environmentAdapter.development;
      case production:
        return environmentAdapter.production;
      default:
        throw Exception('Unknown environment $environment');
    }
  }
}
