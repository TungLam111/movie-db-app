import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_delete_session.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_login.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_token.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_with_login.dart';

abstract class AuthRepository {
  Future<DataState<RequestTokenResponse>> createRequestToken();
  Future<DataState<SessionResponse>> createSession(ReqToken requestToken);
  Future<DataState<SessionWithLoginResponse>> createSessionWithLogin(
    ReqLogin reqLogin,
  );
  Future<DataState<dynamic>> deleteSession(
    ReqDeleteSession requestDelete,
  );
}
