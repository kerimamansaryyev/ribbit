// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reminder_content_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReminderContentRequest _$UpdateReminderContentRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateReminderContentRequest(
      reminderId: json['reminderId'] as String,
      title: json['title'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$UpdateReminderContentRequestToJson(
        UpdateReminderContentRequest instance) =>
    <String, dynamic>{
      'reminderId': instance.reminderId,
      'title': instance.title,
      'notes': instance.notes,
    };
