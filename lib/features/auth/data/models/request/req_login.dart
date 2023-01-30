class ReqLogin {
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
