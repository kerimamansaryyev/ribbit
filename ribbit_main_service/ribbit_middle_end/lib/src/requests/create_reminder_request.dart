import 'package:json_annotation/json_annotation.dart';

part 'create_reminder_request.g.dart';

@JsonSerializable()
class CreateReminderRequest {
  final String title;
  final String notes;
  final DateTime? remindAt;

  const CreateReminderRequest({
    required this.title,
    required this.notes,
    required this.remindAt,
  });

  factory CreateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReminderRequestToJson(this);
}
