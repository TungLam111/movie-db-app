import 'dart:io';

import 'package:mock_bloc_stream/features/auth/data/datasources/auth_datasources.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_token.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_login.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request/req_delete_session.dart';
import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/features/auth/domain/repositories/auth_repository.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authDatasource});
  final AuthDatasource authDatasource;

  @override
  Future<Either<Failure, RequestTokenResponse>> createRequestToken() async {
    try {
      final RequestTokenResponse result =
          await authDatasource.createRequestToken();
      return Right<Failure, RequestTokenResponse>(
        result,
      );
    } on ServerException {
      return const Left<Failure, RequestTokenResponse>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, RequestTokenResponse>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, SessionResponse>> createSession(
    ReqToken requestToken,
  ) async {
    try {
      final SessionResponse result =
          await authDatasource.createSession(requestToken);
      return Right<Failure, SessionResponse>(
        result,
      );
    } on ServerException {
      return const Left<Failure, SessionResponse>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, SessionResponse>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, SessionWithLoginResponse>> createSessionWithLogin(
    ReqLogin reqLogin,
  ) async {
    try {
      final SessionWithLoginResponse result =
          await authDatasource.createSessionWithLogin(reqLogin);
      return Right<Failure, SessionWithLoginResponse>(
        result,
      );
    } on ServerException {
      return const Left<Failure, SessionWithLoginResponse>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, SessionWithLoginResponse>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteSession(
    ReqDeleteSession requestDelete,
  ) async {
    try {
      dynamic result = await authDatasource.deleteSession(requestDelete);
      return Right<Failure, dynamic>(result);
    } on ServerException {
      return const Left<Failure, dynamic>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, dynamic>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }
}
