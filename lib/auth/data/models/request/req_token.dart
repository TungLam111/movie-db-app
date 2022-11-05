class ReqToken {
  ReqToken({this.requestToken});
  String? requestToken;

  toJson() => <String, dynamic>{'request_token': requestToken};
}
