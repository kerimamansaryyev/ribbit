// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reschedule_reminder_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RescheduleReminderRequest _$RescheduleReminderRequestFromJson(
        Map<String, dynamic> json) =>
    RescheduleReminderRequest(
      reminderId: json['reminderId'] as String,
      newDate: json['newDate'] == null
          ? null
          : DateTime.parse(json['newDate'] as String),
    );

Map<String, dynamic> _$RescheduleReminderRequestToJson(
        RescheduleReminderRequest instance) =>
    <String, dynamic>{
      'reminderId': instance.reminderId,
      'newDate': instance.newDate?.toIso8601String(),
    };
