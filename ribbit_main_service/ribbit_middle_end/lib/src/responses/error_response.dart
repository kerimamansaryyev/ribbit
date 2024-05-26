import 'package:json_annotation/json_annotation.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  const ErrorResponse({
    required this.message,
    required this.ribbitServerErrorCode,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
  final String message;
  final RibbitServerErrorCode ribbitServerErrorCode;

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
