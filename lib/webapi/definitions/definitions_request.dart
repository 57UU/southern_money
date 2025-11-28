import 'package:json_annotation/json_annotation.dart';

part 'definitions_request.g.dart';

@JsonSerializable()
class LoginByPasswordRequest {
  static const String route = "/login/loginByPassword";
  @JsonKey(name: "Name")
  final String username;
  @JsonKey(name: "Password")
  final String password;

  LoginByPasswordRequest({required this.username, required this.password});
  Map<String, dynamic> toJson() => _$LoginByPasswordRequestToJson(this);
}
