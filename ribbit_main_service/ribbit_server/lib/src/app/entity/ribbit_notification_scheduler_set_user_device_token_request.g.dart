// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ribbit_notification_scheduler_set_user_device_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RibbitNotificationSchedulerSetUserDeviceTokenRequest
    _$RibbitNotificationSchedulerSetUserDeviceTokenRequestFromJson(
            Map<String, dynamic> json) =>
        RibbitNotificationSchedulerSetUserDeviceTokenRequest(
          userId: json['user_id'] as String,
          deviceToken: json['device_token'] as String,
        );

Map<String, dynamic>
    _$RibbitNotificationSchedulerSetUserDeviceTokenRequestToJson(
            RibbitNotificationSchedulerSetUserDeviceTokenRequest instance) =>
        <String, dynamic>{
          'device_token': instance.deviceToken,
          'user_id': instance.userId,
        };
