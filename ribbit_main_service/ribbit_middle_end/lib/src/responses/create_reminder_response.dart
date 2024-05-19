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
  final CreateReminderResponseReminderDTO reminder;

  CreateReminderResponse({
    required this.reminder,
  });

  factory CreateReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReminderResponseToJson(this);
}
