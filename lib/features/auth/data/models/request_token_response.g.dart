// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestTokenResponse _$RequestTokenResponseFromJson(
        Map<String, dynamic> json) =>
    RequestTokenResponse(
      expiresAt: json['expires_at'] as String?,
      requestToken: json['request_token'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$RequestTokenResponseToJson(
        RequestTokenResponse instance) =>
    <String, dynamic>{
      'request_token': instance.requestToken,
      'expires_at': instance.expiresAt,
      'success': instance.success,
    };
