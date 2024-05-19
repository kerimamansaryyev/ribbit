// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reminder_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReminderResponse _$CreateReminderResponseFromJson(
        Map<String, dynamic> json) =>
    CreateReminderResponse(
      reminder: _$recordConvert(
        json['reminder'],
        ($jsonValue) => (
          notes: $jsonValue['notes'] as String?,
          remindAt: $jsonValue['remindAt'] == null
              ? null
              : DateTime.parse($jsonValue['remindAt'] as String),
          title: $jsonValue['title'] as String?,
          userId: $jsonValue['userId'] as String?,
        ),
      ),
    );

Map<String, dynamic> _$CreateReminderResponseToJson(
        CreateReminderResponse instance) =>
    <String, dynamic>{
      'reminder': <String, dynamic>{
        'notes': instance.reminder.notes,
        'remindAt': instance.reminder.remindAt?.toIso8601String(),
        'title': instance.reminder.title,
        'userId': instance.reminder.userId,
      },
    };

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
