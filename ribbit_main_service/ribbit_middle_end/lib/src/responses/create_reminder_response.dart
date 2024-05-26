import 'package:json_annotation/json_annotation.dart';

part 'create_reminder_response.g.dart';

typedef CreateReminderResponseReminderDTO = ({
  String? userId,
  String? title,
  String? notes,
  DateTime? remindAt,
});

@JsonSerializable()
class CreateReminderResponse {
  CreateReminderResponse({
    required this.reminder,
  });

  factory CreateReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderResponseFromJson(json);
  final CreateReminderResponseReminderDTO reminder;

  Map<String, dynamic> toJson() => _$CreateReminderResponseToJson(this);
}
