import 'package:json_annotation/json_annotation.dart';

part 'create_user_request.g.dart';

@JsonSerializable()
class CreateUserRequest {
  const CreateUserRequest({
    required this.email,
    required this.firstName,
    required this.password,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);
  final String email;
  final String firstName;
  final String password;

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}
