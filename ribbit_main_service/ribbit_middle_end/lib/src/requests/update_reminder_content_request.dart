import 'package:json_annotation/json_annotation.dart';

part 'update_reminder_content_request.g.dart';

@JsonSerializable()
final class UpdateReminderContentRequest {
  const UpdateReminderContentRequest({
    required this.reminderId,
    this.title,
    this.notes,
  });

  factory UpdateReminderContentRequest.fromJson(Map<String, dynamic> data) =>
      _$UpdateReminderContentRequestFromJson(data);

  final String reminderId;
  final String? title;
  final String? notes;

  Map<String, dynamic> toJson() => _$UpdateReminderContentRequestToJson(this);
}
