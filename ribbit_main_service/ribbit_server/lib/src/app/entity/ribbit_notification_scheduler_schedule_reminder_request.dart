import 'package:json_annotation/json_annotation.dart';

part 'ribbit_notification_scheduler_schedule_reminder_request.g.dart';

@JsonSerializable()
final class RibbitNotificationSchedulerScheduleReminderRequest {
  const RibbitNotificationSchedulerScheduleReminderRequest({
    required this.reminderId,
    required this.reminderDate,
    required this.reminderTitle,
    required this.reminderDescription,
    required this.userId,
  });

  @JsonKey(name: 'reminder_id')
  final String reminderId;
  @JsonKey(name: 'reminder_date')
  final DateTime reminderDate;
  @JsonKey(name: 'reminder_title')
  final String reminderTitle;
  @JsonKey(name: 'reminder_description')
  final String reminderDescription;
  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() =>
      _$RibbitNotificationSchedulerScheduleReminderRequestToJson(
        this,
      );
}
