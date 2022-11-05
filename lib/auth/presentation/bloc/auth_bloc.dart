import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:mock_bloc_stream/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/auth/domain/usecases/auth_usecase.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/core/shared_pref_service.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BaseBloc {
  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
  });

  final LogoutUsecase logoutUsecase;
  final LoginUsecase loginUsecase;

  final BehaviorSubject<RequestState> _loginState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get loginStateStream =>
      _loginState.stream.asBroadcastStream();

  get getStateSubject => _loginState;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;

  void resetController() {
    _usernameController.clear();
    _passwordController.clear();
  }

  void saveTokenToStorage() {}

  Future<void> getToken() async {}

  Future<void> createSessionWithLogin() async {
    _loginState.add(RequestState.loading);
    final Either<Failure, RequestTokenResponse> tokenResult =
        await loginUsecase.createRequestToken();
    tokenResult.fold(
      (Failure failure) {
        _loginState.add(RequestState.error);
        message.add('Can not create request token');
        return Future<void>.value();
      },
      (RequestTokenResponse data) async {
        log(data.requestToken!);
        await locator<SharedPreferenceService>()
            .setUserToken(data.requestToken!);
      },
    );


    final Either<Failure, SessionWithLoginResponse> result =
        await loginUsecase.createSessionWithLogin(
      username: _usernameController.text,
      password: _passwordController.text,
      requestToken: locator<SharedPreferenceService>().getUserToken()!,
    );

    result.fold(
      (Failure failure) {
        _loginState.add(RequestState.error);
        message.add(failure.message);
      },
      (SessionWithLoginResponse data) {
        _loginState.add(RequestState.loaded);
      },
    );
  }

  @override
  void dispose() {
    _loginState.close();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
