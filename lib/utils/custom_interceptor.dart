import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomInterceptors extends Interceptor {
  // Stream to send data outside
  final StreamController<RequestOptions> _requestStream =
      StreamController<RequestOptions>.broadcast();

  Stream<RequestOptions> get onRequestStream => _requestStream.stream;

  final StreamController<Response<dynamic>> _responseStream =
      StreamController<Response<dynamic>>.broadcast();

  Stream<Response<dynamic>> get onResponseStream => _responseStream.stream;

  final StreamController<DioError> _errorStream =
      StreamController<DioError>.broadcast();

  Stream<DioError> get onErrorStream => _errorStream.stream;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logCurl(options);

    log('''=>>${options.path}\n->Headers: ${options.headers}\n->Body: ${inspect(options.data)}''');

    _requestStream.add(options);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log('''RESPONSE[${response.statusCode}] => PATH: ${response.realUri.path}\n=>> Data: ${response.data}''');
    _responseStream.add(response);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('''ERROR[${err.response?.statusCode}] => PATH: ${err.response?.realUri.path}\n=>> ${err.response?.data}''');
    _errorStream.add(err);
    return super.onError(err, handler);
  }

  void _logCurl(RequestOptions options) {
    String curl = 'curl --location --request';
    curl += ' ${options.method} ';
    curl += '\'${options.uri.toString()}\'';
    curl += ' \\';
    curl += '--header \'Content-Type: application/json\' \\';
    curl += '--data-raw \'';
    curl += json.encode(options.data);
    curl += '\'';
    log(curl);
  }
}

class CheckTokenAuthenticationInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? accessToken =
        locator<SharedPreferences>().getString('user_token');
    if (accessToken?.isNotEmpty == true) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      options.headers.remove('Authorization');
    }
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {}

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {}
}
