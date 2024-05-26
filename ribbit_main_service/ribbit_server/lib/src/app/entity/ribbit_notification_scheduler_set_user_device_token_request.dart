import 'package:json_annotation/json_annotation.dart';

part 'ribbit_notification_scheduler_set_user_device_token_request.g.dart';

@JsonSerializable()
final class RibbitNotificationSchedulerSetUserDeviceTokenRequest {
  const RibbitNotificationSchedulerSetUserDeviceTokenRequest({
    required this.userId,
    required this.deviceToken,
  });

  @JsonKey(name: 'device_token')
  final String deviceToken;
  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() =>
      _$RibbitNotificationSchedulerSetUserDeviceTokenRequestToJson(
        this,
      );
}
