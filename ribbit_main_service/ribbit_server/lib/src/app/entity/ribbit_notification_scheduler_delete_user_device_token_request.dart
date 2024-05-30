import 'package:json_annotation/json_annotation.dart';

part 'ribbit_notification_scheduler_delete_user_device_token_request.g.dart';

@JsonSerializable()
final class RibbitNotificationSchedulerDeleteUserDeviceTokenRequest {
  const RibbitNotificationSchedulerDeleteUserDeviceTokenRequest({
    required this.userId,
  });

  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() =>
      _$RibbitNotificationSchedulerDeleteUserDeviceTokenRequestToJson(
        this,
      );
}
