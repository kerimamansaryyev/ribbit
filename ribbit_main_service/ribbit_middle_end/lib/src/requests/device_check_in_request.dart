import 'package:json_annotation/json_annotation.dart';

part 'device_check_in_request.g.dart';

@JsonSerializable()
class DeviceCheckInRequest {
  const DeviceCheckInRequest({
    required this.deviceUserToken,
  });

  factory DeviceCheckInRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceCheckInRequestFromJson(json);

  final String deviceUserToken;

  Map<String, dynamic> toJson() => _$DeviceCheckInRequestToJson(this);
}
