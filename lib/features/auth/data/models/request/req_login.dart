import 'package:mock_bloc_stream/core/extension/base_model.dart';

class ReqLogin extends AppModel{
  ReqLogin({
    this.password,
    this.requestToken,
    this.username,
  });
  String? username;
  String? password;
  String? requestToken;

  toJson() => <String, dynamic>{
        'password': password,
        'request_token': requestToken,
        'username': username
      };
}
