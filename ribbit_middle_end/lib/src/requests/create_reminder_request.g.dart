// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reminder_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReminderRequest _$CreateReminderRequestFromJson(
        Map<String, dynamic> json) =>
    CreateReminderRequest(
      title: json['title'] as String,
      notes: json['notes'] as String,
      remindAt: json['remindAt'] == null
          ? null
          : DateTime.parse(json['remindAt'] as String),
    );

Map<String, dynamic> _$CreateReminderRequestToJson(
        CreateReminderRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'notes': instance.notes,
      'remindAt': instance.remindAt?.toIso8601String(),
    };
