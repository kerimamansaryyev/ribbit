import 'package:json_annotation/json_annotation.dart';

part 'ribbit_notification_scheduler_cancel_reminder_request.g.dart';

@JsonSerializable()
final class RibbitNotificationSchedulerCancelReminderRequest {
  const RibbitNotificationSchedulerCancelReminderRequest({
    required this.reminderId,
  });

  @JsonKey(name: 'reminder_id')
  final String reminderId;

  Map<String, dynamic> toJson() =>
      _$RibbitNotificationSchedulerCancelReminderRequestToJson(
        this,
      );
}
