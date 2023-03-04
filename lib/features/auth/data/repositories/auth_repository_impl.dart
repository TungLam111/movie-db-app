import 'dart:io';

import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/auth/data/datasources/auth_datasources.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_token.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_login.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_delete_session.dart';
import 'package:mock_bloc_stream/features/auth/domain/repositories/auth_repository.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authDatasource});
  final AuthDatasource authDatasource;

  @override
  Future<DataState<RequestTokenResponse>> createRequestToken() async {
    try {
      final RequestTokenResponse result =
          await authDatasource.createRequestToken();
      return DataSuccess<RequestTokenResponse>(
        result,
      );
    } on ServerException {
      return DataFailed<RequestTokenResponse>(Exception(''));
    } on SocketException {
      return DataFailed<RequestTokenResponse>(
        Exception('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<SessionResponse>> createSession(
    ReqToken requestToken,
  ) async {
    try {
      final SessionResponse result =
          await authDatasource.createSession(requestToken);
      return DataSuccess<SessionResponse>(
        result,
      );
    } on ServerException {
      return DataFailed<SessionResponse>(ServerException());
    } on SocketException {
      return const DataFailed<SessionResponse>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<SessionWithLoginResponse>> createSessionWithLogin(
    ReqLogin reqLogin,
  ) async {
    try {
      final SessionWithLoginResponse result =
          await authDatasource.createSessionWithLogin(reqLogin);
      return DataSuccess<SessionWithLoginResponse>(
        result,
      );
    } on ServerException {
      return DataFailed<SessionWithLoginResponse>(ServerException());
    } on SocketException {
      return const DataFailed<SessionWithLoginResponse>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<dynamic>> deleteSession(
    ReqDeleteSession requestDelete,
  ) async {
    try {
      dynamic result = await authDatasource.deleteSession(requestDelete);
      return DataSuccess<dynamic>(result);
    } on ServerException {
      return DataFailed<dynamic>(ServerException());
    } on SocketException {
      return const DataFailed<dynamic>(
        SocketException('Failed to connect to the network'),
      );
    }
  }
}
