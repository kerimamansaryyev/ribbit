import 'package:json_annotation/json_annotation.dart';

part 'login_user_response.g.dart';

typedef LoginUserResponseUserDTO = ({
  String? userId,
  String? email,
  String? firstName,
});

@JsonSerializable()
class LoginUserResponse {
  final LoginUserResponseUserDTO user;
  final String? accessToken;

  LoginUserResponse({
    required this.user,
    required this.accessToken,
  });

  factory LoginUserResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserResponseToJson(this);
}