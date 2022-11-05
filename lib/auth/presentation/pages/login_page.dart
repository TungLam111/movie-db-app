import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mock_bloc_stream/auth/presentation/bloc/auth_bloc.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:mock_bloc_stream/widgets/custom_button.dart';
import 'package:mock_bloc_stream/widgets/custom_input_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late StreamSubscription<RequestState> _loginStateSubscription;
  @override
  void initState() {
    super.initState();
    _loginStateSubscription = Provider.of<AuthBloc>(context, listen: false)
        .loginStateStream
        .listen((RequestState event) {
      if (event == RequestState.loading) {
        EasyLoading.show();
      } else if (event == RequestState.loaded) {
        EasyLoading.showSuccess('Success');
      } else if (event == RequestState.error) {
        EasyLoading.showError('Error');
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  @override
  void dispose() {
    _loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.kFF21252B,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 70,
                ),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildEmail(),
                const SizedBox(
                  height: 30,
                ),
                _buildPassword(),
                const SizedBox(height: 20),
                _buildForgotPass(),
                const SizedBox(
                  height: 40,
                ),
                _buildButtons(),
                const SizedBox(
                  height: 40,
                ),
                _buildNotHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Login',
          style: StylesConstant.ts23w700,
        ),
        Row(
          children: <Widget>[
            Text(
              "Dont't have an account?",
              style: StylesConstant.ts13w400,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Sign Up',
              style: StylesConstant.ts13w700.copyWith(
                decoration: TextDecoration.underline,
                color: ColorConstant.kFF03A87C,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildEmail() {
    return CustomInputWidget(
      controller:
          Provider.of<AuthBloc>(context, listen: false).usernameController,
      labelText: 'Username',
      labelStyle: StylesConstant.ts13w400.copyWith(
        color: ColorConstant.kFF9CA5B4,
      ),
    );
  }

  Widget _buildPassword() {
    return CustomInputWidget(
      controller:
          Provider.of<AuthBloc>(context, listen: false).passwordController,
      labelText: 'Password',
      labelStyle: StylesConstant.ts13w400.copyWith(
        color: ColorConstant.kFF9CA5B4,
      ),
    );
  }

  Widget _buildForgotPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Forgot your password?',
          style: StylesConstant.ts13w700.copyWith(
            color: ColorConstant.kFF9CA5B4,
            decoration: TextDecoration.underline,
          ),
        )
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        CustomButton(
          params: CustomButtonParams.primary(
            backgroundColor: ColorConstant.kFF0071DF,
            text: 'Log In',
            onPressed: onLogin,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'or',
            style: StylesConstant.ts16w400
                .copyWith(color: ColorConstant.kFF9CA5B4),
          ),
        ),
        CustomButton(
          params: CustomButtonParams.primary(
            backgroundColor: ColorConstant.kFF181A1F,
            text: 'Log In with Google',
          ),
        ),
      ],
    );
  }

  Widget _buildNotHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Dont't have an account?",
          style: StylesConstant.ts16w400,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          'Sign Up',
          style: StylesConstant.ts16w700.copyWith(
            decoration: TextDecoration.underline,
            color: ColorConstant.kFF03A87C,
          ),
        )
      ],
    );
  }

  void onLogin() async {
    Provider.of<AuthBloc>(context, listen: false).createSessionWithLogin();
  }
}
