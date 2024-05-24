// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ribbit_notification_scheduler_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RibbitNotificationSchedulerLoginRequest
    _$RibbitNotificationSchedulerLoginRequestFromJson(
            Map<String, dynamic> json) =>
        RibbitNotificationSchedulerLoginRequest(
          password: json['password'] as String,
          userName: json['username'] as String,
        );

Map<String, dynamic> _$RibbitNotificationSchedulerLoginRequestToJson(
        RibbitNotificationSchedulerLoginRequest instance) =>
    <String, dynamic>{
      'username': instance.userName,
      'password': instance.password,
    };
