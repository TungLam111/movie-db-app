class ReqDeleteSession {
  ReqDeleteSession({this.sessionId});
  String? sessionId;

  toJson() => <String, dynamic>{
        'session_id': sessionId,
      };
}
