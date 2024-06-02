// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ribbit_notification_scheduler_cancel_reminder_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RibbitNotificationSchedulerCancelReminderRequest
    _$RibbitNotificationSchedulerCancelReminderRequestFromJson(
            Map<String, dynamic> json) =>
        RibbitNotificationSchedulerCancelReminderRequest(
          reminderId: json['reminder_id'] as String,
        );

Map<String, dynamic> _$RibbitNotificationSchedulerCancelReminderRequestToJson(
        RibbitNotificationSchedulerCancelReminderRequest instance) =>
    <String, dynamic>{
      'reminder_id': instance.reminderId,
    };
