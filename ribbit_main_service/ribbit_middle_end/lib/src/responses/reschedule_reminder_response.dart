import 'package:json_annotation/json_annotation.dart';

part 'reschedule_reminder_response.g.dart';

typedef RescheduleReminderResponseReminderDTO = ({
  String? reminderId,
  String? userId,
  String? title,
  String? notes,
  DateTime? remindAt,
});

@JsonSerializable()
class RescheduleReminderResponse {
  RescheduleReminderResponse({
    required this.reminder,
  });

  factory RescheduleReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$RescheduleReminderResponseFromJson(json);
  final RescheduleReminderResponseReminderDTO reminder;

  Map<String, dynamic> toJson() => _$RescheduleReminderResponseToJson(this);
}
