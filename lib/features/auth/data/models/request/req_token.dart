import 'package:mock_bloc_stream/core/extension/base_model.dart';

class ReqToken extends AppModel{
  ReqToken({this.requestToken});
  String? requestToken;

  toJson() => <String, dynamic>{'request_token': requestToken};
}
