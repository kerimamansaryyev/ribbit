// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      message: json['message'] as String,
      ribbitServerErrorCode: $enumDecode(
          _$RibbitServerErrorCodeEnumMap, json['ribbitServerErrorCode']),
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'ribbitServerErrorCode':
          _$RibbitServerErrorCodeEnumMap[instance.ribbitServerErrorCode]!,
    };

const _$RibbitServerErrorCodeEnumMap = {
  RibbitServerErrorCode.unexpectedError: 'UNEXPECTED_ERROR',
  RibbitServerErrorCode.loginFailed: 'LOGIN_FAILED',
  RibbitServerErrorCode.invalidRequestFormat: 'INVALID_REQUEST_FORMAT',
  RibbitServerErrorCode.userAlreadyExists: 'USER_ALREADY_EXISTS',
  RibbitServerErrorCode.unauthorized: 'UNAUTHORIZED',
  RibbitServerErrorCode.userNotFound: 'USER_NOT_FOUNT',
  RibbitServerErrorCode.reminderNotFound: 'REMINDER_NOT_FOUND',
  RibbitServerErrorCode.reminderLostUpdate: 'REMINDER_LOST_UPDATE',
  RibbitServerErrorCode.invalidInput: 'INVALID_INPUT',
};
