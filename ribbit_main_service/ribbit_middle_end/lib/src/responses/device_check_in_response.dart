import 'package:json_annotation/json_annotation.dart';

part 'device_check_in_response.g.dart';

@JsonSerializable()
class DeviceCheckInResponse {
  const DeviceCheckInResponse({
    required this.message,
  });

  factory DeviceCheckInResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceCheckInResponseFromJson(json);

  final String message;

  Map<String, dynamic> toJson() => _$DeviceCheckInResponseToJson(this);
}
