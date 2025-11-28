// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definitions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginByPasswordRequest _$LoginByPasswordRequestFromJson(
  Map<String, dynamic> json,
) => LoginByPasswordRequest(
  username: json['Name'] as String,
  password: json['Password'] as String,
);

Map<String, dynamic> _$LoginByPasswordRequestToJson(
  LoginByPasswordRequest instance,
) => <String, dynamic>{
  'Name': instance.username,
  'Password': instance.password,
};
