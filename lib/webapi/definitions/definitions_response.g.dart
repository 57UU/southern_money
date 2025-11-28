// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definitions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['Success'] as bool,
  message: json['Message'] as String?,
  data: _$nullableGenericFromJson(json['Data'], fromJsonT),
  timestamp: json['Timestamp'] == null
      ? null
      : DateTime.parse(json['Timestamp'] as String),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'Success': instance.success,
  'Message': instance.message,
  'Data': _$nullableGenericToJson(instance.data, toJsonT),
  'Timestamp': instance.timestamp?.toIso8601String(),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

TestResponse _$TestResponseFromJson(Map<String, dynamic> json) =>
    TestResponse(message: json['Message'] as String);

Map<String, dynamic> _$TestResponseToJson(TestResponse instance) =>
    <String, dynamic>{'Message': instance.message};
