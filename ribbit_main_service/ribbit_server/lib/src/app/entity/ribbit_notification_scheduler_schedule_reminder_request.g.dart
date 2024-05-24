// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ribbit_notification_scheduler_schedule_reminder_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RibbitNotificationSchedulerScheduleReminderRequest
    _$RibbitNotificationSchedulerScheduleReminderRequestFromJson(
            Map<String, dynamic> json) =>
        RibbitNotificationSchedulerScheduleReminderRequest(
          reminderId: json['reminder_id'] as String,
          reminderDate: DateTime.parse(json['reminder_date'] as String),
          reminderTitle: json['reminder_title'] as String,
          reminderDescription: json['reminder_description'] as String,
          userId: json['user_id'] as String,
        );

Map<String, dynamic> _$RibbitNotificationSchedulerScheduleReminderRequestToJson(
        RibbitNotificationSchedulerScheduleReminderRequest instance) =>
    <String, dynamic>{
      'reminder_id': instance.reminderId,
      'reminder_date': instance.reminderDate.toIso8601String(),
      'reminder_title': instance.reminderTitle,
      'reminder_description': instance.reminderDescription,
      'user_id': instance.userId,
    };
