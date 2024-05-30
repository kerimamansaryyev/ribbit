import 'package:json_annotation/json_annotation.dart';

part 'logout_user_response.g.dart';

@JsonSerializable()
class LogoutUserResponse {
  LogoutUserResponse({
    required this.message,
  });

  factory LogoutUserResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutUserResponseFromJson(json);

  final String message;

  Map<String, dynamic> toJson() => _$LogoutUserResponseToJson(this);
}
