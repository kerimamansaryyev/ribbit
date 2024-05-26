import 'package:json_annotation/json_annotation.dart';

part 'create_user_response.g.dart';

typedef CreateUserResponseUserDTO = ({
  String? userId,
  String? email,
  String? firstName,
});

@JsonSerializable()
class CreateUserResponse {
  CreateUserResponse({
    required this.user,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);
  final CreateUserResponseUserDTO user;

  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);
}
