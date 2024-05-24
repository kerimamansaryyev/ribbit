import 'package:json_annotation/json_annotation.dart';

part 'ribbit_notification_scheduler_login_request.g.dart';

@JsonSerializable()
final class RibbitNotificationSchedulerLoginRequest {
  const RibbitNotificationSchedulerLoginRequest({
    required this.password,
    required this.userName,
  });

  @JsonKey(name: 'username')
  final String userName;
  @JsonKey(name: 'password')
  final String password;

  Map<String, dynamic> toJson() =>
      _$RibbitNotificationSchedulerLoginRequestToJson(
        this,
      );
}
