import 'package:json_annotation/json_annotation.dart';

part 'delete_own_user_account_response.g.dart';

@JsonSerializable()
class DeleteOwnUserAccountResponse {
  final String message;

  DeleteOwnUserAccountResponse({
    required this.message,
  });

  factory DeleteOwnUserAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteOwnUserAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteOwnUserAccountResponseToJson(this);
}
