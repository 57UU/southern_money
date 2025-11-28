import 'package:json_annotation/json_annotation.dart';

part 'definitions_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: "Success")
  final bool success;
  @JsonKey(name: "Message")
  final String? message;
  @JsonKey(name: "Data")
  final T? data;
  @JsonKey(name: "Timestamp")
  final DateTime? timestamp;

  ApiResponse({required this.success, this.message, this.data, this.timestamp});
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
  factory ApiResponse.fail({String? message}) =>
      ApiResponse<T>(success: false, message: message);
}

@JsonSerializable()
class TestResponse {
  @JsonKey(name: "Message")
  final String message;

  TestResponse({required this.message});
  factory TestResponse.fromJson(Map<String, dynamic> json) =>
      _$TestResponseFromJson(json);
}
