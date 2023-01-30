import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_delete_session.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_login.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_token.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/features/auth/domain/repositories/auth_repository.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

class LoginUsecase {
  LoginUsecase(this.repository);
  final AuthRepository repository;

  Future<Either<Failure, SessionWithLoginResponse>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    return await repository.createSessionWithLogin(
      ReqLogin(
        username: username,
        password: password,
        requestToken: requestToken,
      ),
    );
  }

  Future<Either<Failure, RequestTokenResponse>> createRequestToken() async {
    return await repository.createRequestToken();
  }

  Future<Either<Failure, SessionResponse>> createSession(
    ReqToken requestToken,
  ) async {
    return await repository.createSession(requestToken);
  }
}

class LogoutUsecase {
  LogoutUsecase(this.repository);
  final AuthRepository repository;

  Future<Either<Failure, dynamic>> deleteSession(
    ReqDeleteSession requestDelete,
  ) async {
    return await repository.deleteSession(requestDelete);
  }
}
