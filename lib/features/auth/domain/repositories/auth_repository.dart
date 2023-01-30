import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_delete_session.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_login.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_token.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

abstract class AuthRepository {
  Future<Either<Failure, RequestTokenResponse>> createRequestToken();
  Future<Either<Failure, SessionResponse>> createSession(ReqToken requestToken);
  Future<Either<Failure, SessionWithLoginResponse>> createSessionWithLogin(
    ReqLogin reqLogin,
  );
  Future<Either<Failure, dynamic>> deleteSession(
    ReqDeleteSession requestDelete,
  );
}
