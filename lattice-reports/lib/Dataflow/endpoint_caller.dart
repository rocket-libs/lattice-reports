import 'dart:io';

import 'package:lattice_reports/ApplicationInformation/Data/application_information_messenger.dart';
import 'package:lattice_reports/Dataflow/http_model_base.dart';
import 'package:http/http.dart' as http;
import 'package:lattice_reports/Dataflow/micro_service_enum.dart';
import 'package:lattice_reports/Dataflow/network_information.dart';
import 'package:lattice_reports/Dataflow/offline_response.dart';
import 'package:lattice_reports/Dataflow/offline_support_helper.dart';
import 'package:lattice_reports/Dataflow/rest_exception.dart';
import 'package:lattice_reports/Dataflow/rest_settings.dart';
import 'package:lattice_reports/Logging/logger_wrapper.dart';
import 'http_methods_enum.dart';
import 'dart:convert' as convert;

class EndpointCaller {
  final MicroServiceEnum targetMicroService;

  EndpointCaller.lattice() : targetMicroService = MicroServiceEnum.lattice;
  EndpointCaller(this.targetMicroService);

  Future<TResult> getAsync<TResult>(String relativeUrl,
      {String? offlineDisplayLabel,
      bool disableUrlEncoding = false,
      bool includeStoreId = true}) async {
    return await _callAsync(relativeUrl, (fullUrl, json, requestHeaders) async {
      var apiResult = await http.get(fullUrl, headers: requestHeaders);
      return apiResult;
    }, disableUrlEncoding, HttpMethodsEnum.get,
        offlineDisplayLabel: offlineDisplayLabel,
        includeStoreId: includeStoreId);
  }

  Future<TResult> deleteAsync<TResult>(String relativeUrl,
      {bool disableUrlEncoding = false, required bool includeStoreId}) async {
    return await _callAsync(relativeUrl, (fullUrl, json, requestHeaders) async {
      var apiResult = await http.delete(fullUrl, headers: requestHeaders);
      return apiResult;
    }, disableUrlEncoding, HttpMethodsEnum.delete,
        includeStoreId: includeStoreId);
  }

  Future<TResult> postModelAsync<TResult>(relativeUrl, HttpModelBase model,
      {String offlineDisplayLabel = "",
      bool disableUrlEncoding = false,
      bool includeStoreId = true}) async {
    var json = model.toJson();
    return await postMapAsync<TResult>(relativeUrl, json,
        disableUrlEncoding: disableUrlEncoding,
        offlineDisplayLabel: offlineDisplayLabel,
        includeStoreId: includeStoreId);
  }

  Future<TResult> postMapAsync<TResult>(relativeUrl, payload,
      {String offlineDisplayLabel = "",
      bool disableUrlEncoding = false,
      required includeStoreId}) async {
    return await _callAsync(relativeUrl, (
      fullUrl,
      json,
      requestHeaders,
    ) async {
      return await http.post(fullUrl, body: json, headers: requestHeaders);
    }, disableUrlEncoding, HttpMethodsEnum.post,
        payload: payload,
        offlineDisplayLabel: offlineDisplayLabel,
        includeStoreId: includeStoreId);
  }

  _appendEnvironmentHeadersAsync(Map<String, String> requestHeaders,
      {required bool includeStoreId}) async {
    final environmentAdapter = RestSettings.getEnvironmentAdapter(
        targetMicroService,
        includeStoreId: includeStoreId);
    requestHeaders =
        await environmentAdapter.appendHeadersAsync(requestHeaders);
  }

  Future<bool> _hasConnectionAsync(bool supportsOffline) async {
    if (supportsOffline) {
      if (RestSettings.mockOffline) {
        return false;
      }
      return await NetworkInformation.hasConnectionAsync();
    } else {
      return true;
    }
  }

  _callAsync(relativeUrl, fn, bool disableUrlEncoding, HttpMethodsEnum method,
      {String? offlineDisplayLabel,
      payload,
      required bool includeStoreId}) async {
    offlineDisplayLabel = (offlineDisplayLabel ?? "").trim();
    bool supportsOffline = offlineDisplayLabel != "";
    final postGZipped = targetMicroService == MicroServiceEnum.lattice;
    final unEncodedUrl = RestSettings.getEndpoint(
        relativeUrl: relativeUrl,
        targetMicroService: targetMicroService,
        includeStoreId: includeStoreId);
    final fullUrl =
        disableUrlEncoding ? unEncodedUrl : Uri.encodeFull(unEncodedUrl);
    const defaultSuccessJson = '{"code":1,"payload": null}';
    const offlineSuccessJson =
        '{"code":1,"payload": "${OfflineResponse.offlineSuccess}"}';
    Function(String) statusCodeLogger;
    dynamic response;
    try {
      LoggerWrapper().i('Entering call to $fullUrl');
      final hasPayload = payload != null;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'X-App-Type': 'mobile',
        'X-App-Version': ApplicationInformationMessenger()
            .applicationInformation
            .applicationVersion,
        'Accept-Encoding': "gzip",
      };
      if (postGZipped) {
        requestHeaders["Content-Encoding"] = "gzip";
      }
      await _appendEnvironmentHeadersAsync(requestHeaders,
          includeStoreId: includeStoreId);

      dynamic dataToPost;
      if (hasPayload) {
        final richPayload = payload;
        richPayload['clientAppType'] = 'mobile';

        final json = convert.jsonEncode(richPayload);
        if (postGZipped) {
          final List<int> gzippedJson = [];
          final gzipCodec = GZipCodec();
          gzippedJson.addAll(gzipCodec.encode(json.codeUnits));
          dataToPost = gzippedJson;
        } else {
          dataToPost = json;
        }
        LoggerWrapper().v(json);
        LoggerWrapper().v("Posting GZipped: $postGZipped");
      }

      LoggerWrapper().v(requestHeaders, title: 'Request Headers');
      LoggerWrapper().i({
        'environment': RestSettings.environment,
      });

      final hasConnection = await _hasConnectionAsync(supportsOffline);
      if (hasConnection) {
        try {
          LoggerWrapper().v("Called $fullUrl");
          LoggerWrapper().v("Waiting response from server...");
          response = await fn(Uri.parse(fullUrl), dataToPost, requestHeaders);
        } finally {
          LoggerWrapper().v("Call to server completed.");
        }
      } else {
        await OfflineSupportHelper().writeAsync(
            relativeUrl: relativeUrl,
            payload: payload,
            method: method,
            offlineDisplayLabel: offlineDisplayLabel);
        response = OfflineResponse(200, offlineSuccessJson);
      }

      var isSuccessStatusCode = response.statusCode == 200;
      statusCodeLogger = isSuccessStatusCode
          ? (s) => LoggerWrapper().i(s)
          : (s) => LoggerWrapper().e(s);
      statusCodeLogger('HTTP STATUS CODE ${response.statusCode}');
      if (response.statusCode == 200) {
        final body =
            response.body != null && response.body.toString().trim() != ""
                ? response.body
                : defaultSuccessJson;
        LoggerWrapper().v("Response body:\n $body");
        var jsonResponse = convert.jsonDecode(body);
        var code = jsonResponse['code'];
        var succeeded = false;
        LoggerWrapper().v('API response code $code');
        if (code != null) {
          succeeded = code.toInt() == 1;
        }
        if (succeeded) {
          return jsonResponse['payload'];
        } else {
          throw RestException(
              message: 'Error occured while communicating with the server');
        }
      } else if (response.statusCode == 401) {
        //_handleUAuthenticatedUser();
        throw RestException(message: "Sign in required");
      } else if (response.statusCode == 400) {
        throw RestException(
            message: "Server rejected your request\n\n${response.body}.");
      } else if (response.statusCode == 402) {
        throw RestException(message: "Payment required");
      } else {
        throw RestException(message: 'Error occured communicating with server');
      }
    } catch (e) {
      LoggerWrapper().e("Error call $fullUrl");
      LoggerWrapper().e(e);
      LoggerWrapper().e(response);
      final exception = RestException(
          message:
              "Something went wrong communicating with the cloud. Please wait a few minutes then try again",
          innerException: e);

      throw exception;
    } finally {
      LoggerWrapper().i('exiting call to $fullUrl');
    }
  }
}
