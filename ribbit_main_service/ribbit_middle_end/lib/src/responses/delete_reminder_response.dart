import 'package:json_annotation/json_annotation.dart';

part 'delete_reminder_response.g.dart';

@JsonSerializable()
final class DeleteReminderResponse {
  const DeleteReminderResponse({
    required this.message,
  });

  factory DeleteReminderResponse.fromJson(Map<String, dynamic> data) =>
      _$DeleteReminderResponseFromJson(data);

  final String message;

  Map<String, dynamic> toJson() => _$DeleteReminderResponseToJson(
        this,
      );
}
