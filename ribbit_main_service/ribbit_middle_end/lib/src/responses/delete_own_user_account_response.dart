import 'package:json_annotation/json_annotation.dart';

part 'delete_own_user_account_response.g.dart';

@JsonSerializable()
class DeleteOwnUserAccountResponse {
  DeleteOwnUserAccountResponse({
    required this.message,
  });

  factory DeleteOwnUserAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteOwnUserAccountResponseFromJson(json);
  final String message;

  Map<String, dynamic> toJson() => _$DeleteOwnUserAccountResponseToJson(this);
}
