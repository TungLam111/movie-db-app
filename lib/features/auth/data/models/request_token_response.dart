import 'package:json_annotation/json_annotation.dart';
part 'request_token_response.g.dart';

@JsonSerializable()
class RequestTokenResponse {
  RequestTokenResponse({
    this.expiresAt,
    this.requestToken,
    this.success,
  });
  factory RequestTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestTokenResponseToJson(this);

  @JsonKey(name: 'request_token')
  String? requestToken;

  @JsonKey(name: 'expires_at')
  String? expiresAt;

  bool? success;
}
