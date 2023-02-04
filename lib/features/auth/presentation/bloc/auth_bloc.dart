import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/features/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/features/auth/domain/usecases/auth_usecase.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/service/user/shared_pref_service.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BaseBloc {
  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
  });

  final LogoutUsecase logoutUsecase;
  final LoginUsecase loginUsecase;

  final BehaviorSubject<RequestState> _loginStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get loginStateStream => _loginStateSubject.stream;

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
    _loginStateSubject.add(RequestState.loading);
    final DataState<RequestTokenResponse> tokenResult =
        await loginUsecase.createRequestToken();
    if (tokenResult.isError()) {
      _loginStateSubject.add(RequestState.error);
      messageSubject.add('Can not create request token');
      return Future<void>.value();
    } else {
      log(tokenResult.data!.requestToken!);
      await locator<SharedPreferenceService>()
          .setUserToken(tokenResult.data!.requestToken!);
    }

    final DataState<SessionWithLoginResponse> result =
        await loginUsecase.createSessionWithLogin(
      username: _usernameController.text,
      password: _passwordController.text,
      requestToken: locator<SharedPreferenceService>().getUserToken()!,
    );

    if (result.isError()) {
      _loginStateSubject.add(RequestState.error);
      messageSubject.add(result.err);
    } else {
      _loginStateSubject.add(RequestState.loaded);
    }
  }

  @override
  void dispose() {
    _loginStateSubject.close();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
