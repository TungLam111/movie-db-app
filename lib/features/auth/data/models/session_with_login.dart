import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/core/extension/base_model.dart';

part 'session_with_login.g.dart';

@JsonSerializable()
class SessionWithLoginResponse extends AppModel {
  SessionWithLoginResponse({
    this.expiresAt,
    this.guestSessionId,
    this.success,
  });
  factory SessionWithLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionWithLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionWithLoginResponseToJson(this);

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'guest_session_id')
  String? guestSessionId;

  @JsonKey(name: 'expires_at')
  String? expiresAt;
}
