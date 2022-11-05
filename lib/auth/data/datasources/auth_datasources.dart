import 'package:mock_bloc_stream/auth/data/models/request/req_delete_session.dart';
import 'package:mock_bloc_stream/auth/data/models/request/req_login.dart';
import 'package:mock_bloc_stream/auth/data/models/request/req_token.dart';
import 'package:mock_bloc_stream/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/auth/data/models/session_response.dart';
import 'package:mock_bloc_stream/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/core/api/api_service.dart';

abstract class AuthDatasource {
  Future<RequestTokenResponse> createRequestToken();
  Future<SessionResponse> createSession(ReqToken requestToken);
  Future<SessionWithLoginResponse> createSessionWithLogin(ReqLogin reqLogin);
  Future<dynamic> deleteSession(
    ReqDeleteSession requestDelete,
  );
}

class AuthDataSourceImpl implements AuthDatasource {
  AuthDataSourceImpl({required this.client});
  final ApiService client;

  @override
  Future<RequestTokenResponse> createRequestToken() async {
    return await client.createRequestToken();
  }

  @override
  Future<SessionResponse> createSession(ReqToken requestToken) async {
    return await client.createSession(
      requestToken: requestToken,
    );
  }

  @override
  Future<SessionWithLoginResponse> createSessionWithLogin(
    ReqLogin reqLogin,
  ) async {
    return await client.createSessionWithLogin(requestLogin: reqLogin);
  }

  @override
  Future<dynamic> deleteSession(
    ReqDeleteSession requestDelete,
  ) async {
    return await client.deleteSession(requestDelete: requestDelete);
  }
}
