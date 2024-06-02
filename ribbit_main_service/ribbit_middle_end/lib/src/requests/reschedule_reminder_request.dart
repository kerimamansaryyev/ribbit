import 'package:json_annotation/json_annotation.dart';

part 'reschedule_reminder_request.g.dart';

@JsonSerializable()
final class RescheduleReminderRequest {
  const RescheduleReminderRequest({
    required this.reminderId,
    required this.newDate,
  });

  factory RescheduleReminderRequest.fromJson(Map<String, dynamic> data) =>
      _$RescheduleReminderRequestFromJson(data);

  final String reminderId;
  final DateTime? newDate;

  Map<String, dynamic> toJson() => _$RescheduleReminderRequestToJson(this);
}
