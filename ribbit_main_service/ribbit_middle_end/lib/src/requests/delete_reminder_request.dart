import 'package:json_annotation/json_annotation.dart';

part 'delete_reminder_request.g.dart';

@JsonSerializable()
final class DeleteReminderRequest {
  const DeleteReminderRequest({
    required this.reminderId,
  });

  factory DeleteReminderRequest.fromJson(Map<String, dynamic> data) =>
      _$DeleteReminderRequestFromJson(data);

  Map<String, dynamic> toJson() => _$DeleteReminderRequestToJson(
        this,
      );

  final String reminderId;
}
