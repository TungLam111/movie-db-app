import 'package:mock_bloc_stream/core/extension/base_model.dart';

class ReqDeleteSession extends AppModel{
  ReqDeleteSession({this.sessionId});
  String? sessionId;

  toJson() => <String, dynamic>{
        'session_id': sessionId,
      };
}
