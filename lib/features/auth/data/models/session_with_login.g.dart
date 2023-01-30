// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_with_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionWithLoginResponse _$SessionWithLoginResponseFromJson(
        Map<String, dynamic> json) =>
    SessionWithLoginResponse(
      expiresAt: json['expires_at'] as String?,
      guestSessionId: json['guest_session_id'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$SessionWithLoginResponseToJson(
        SessionWithLoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'guest_session_id': instance.guestSessionId,
      'expires_at': instance.expiresAt,
    };
