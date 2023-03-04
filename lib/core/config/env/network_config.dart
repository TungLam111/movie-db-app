import 'package:mock_bloc_stream/core/service/user/shared_pref_service.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import '../../extension/extension.dart';

enum BuildMode { dev, stagging, prod }

abstract class NetWorkMode {
  NetWorkMode.internal({
    required this.baseUrl,
    required this.localDBName,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory NetWorkMode({required BuildMode mode}) {
    switch (mode) {
      case BuildMode.prod:
        return ProductionMode();
      case BuildMode.stagging:
        return StagingMode();
      case BuildMode.dev:
        return DevelopmentMode();
    }
  }

  final String baseUrl;
  String localDBName;
  int connectTimeout;
  int receiveTimeout;

  Map<String, String> get headers {
    final String? accessToken =
        locator<SharedPreferenceService>().getUserToken();
    final Map<String, String> headers = <String, String>{
      'accept': '*/*',
      'Content-Type': 'application/json',
      if (!accessToken.isEmptyOrNull()) 'Authorization': 'Bearer $accessToken'
    };
    return headers;
  }
}

class ProductionMode extends NetWorkMode {
  ProductionMode({
    String localDBName = 'local.db',
    String baseUrl = Urls.baseUrl,
    int connectTimeout = Urls.kConnectionTimeOutInMilliSecond,
    int receiveTimeout = Urls.kReceivingTimeOutInMilliSecond,
  }) : super.internal(
          baseUrl: baseUrl,
          localDBName: localDBName,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        );
}

class StagingMode extends NetWorkMode {
  StagingMode({
    String localDBName = 'local.db',
    String baseUrl = Urls.baseUrl,
    int connectTimeout = Urls.kConnectionTimeOutInMilliSecond,
    int receiveTimeout = Urls.kReceivingTimeOutInMilliSecond,
  }) : super.internal(
          baseUrl: baseUrl,
          localDBName: localDBName,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        );
}

class DevelopmentMode extends NetWorkMode {
  DevelopmentMode({
    String localDBName = 'local.db',
    String baseUrl = Urls.baseUrl,
    int connectTimeout = Urls.kConnectionTimeOutInMilliSecond,
    int receiveTimeout = Urls.kReceivingTimeOutInMilliSecond,
  }) : super.internal(
          baseUrl: baseUrl,
          localDBName: localDBName,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        );
}
