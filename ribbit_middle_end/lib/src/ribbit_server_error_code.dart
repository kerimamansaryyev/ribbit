import 'package:json_annotation/json_annotation.dart';

@JsonEnum(
  valueField: 'readableCode',
)
enum RibbitServerErrorCode {
  unexpectedError('UNEXPECTED_ERROR'),
  loginFailed('LOGIN_FAILED'),
  invalidRequestFormat('INVALID_REQUEST_FORMAT'),
  userAlreadyExists('USER_ALREADY_EXISTS'),
  unauthorized('UNAUTHORIZED'),
  userNotFound('USER_NOT_FOUNT');

  const RibbitServerErrorCode(
    this.readableCode,
  );

  final String readableCode;
}
