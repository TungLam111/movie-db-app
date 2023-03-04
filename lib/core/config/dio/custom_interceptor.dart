import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mock_bloc_stream/core/service/user/shared_pref_service.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';

class CustomInterceptors extends Interceptor {

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
    log('''=>>${options.path}\n->Headers: ${options.headers}\n->Body: ${inspect(options.data)}''');
    _requestStream.add(options);
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log('''RESPONSE[${response.statusCode}] => PATH: ${response.realUri.path}\n=>> Data: ${response.data}''');
    _responseStream.add(response);
    return handler.next(response); 
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('''ERROR[${err.response?.statusCode}] => PATH: ${err.response?.realUri.path}\n=>> ${err.response?.data}''');
    _errorStream.add(err);
    return handler.next(err); 
  }
}

class CheckTokenAuthenticationInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? accessToken =
        locator<SharedPreferenceService>().getUserToken();
    if (accessToken?.isNotEmpty == true) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      options.headers.remove('Authorization');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log('Ok');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('Error');
    super.onError(err, handler);
  }
}
