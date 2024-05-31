import 'package:json_annotation/json_annotation.dart';

part 'update_reminder_content_response.g.dart';

typedef UpdateReminderContentResponseReminderDTO = ({
  String? reminderId,
  String? userId,
  String? title,
  String? notes,
  DateTime? remindAt,
});

@JsonSerializable()
class UpdateReminderContentResponse {
  UpdateReminderContentResponse({
    required this.reminder,
  });

  factory UpdateReminderContentResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateReminderContentResponseFromJson(json);
  final UpdateReminderContentResponseReminderDTO reminder;

  Map<String, dynamic> toJson() => _$UpdateReminderContentResponseToJson(this);
}
