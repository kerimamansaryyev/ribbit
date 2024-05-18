// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUserResponse _$LoginUserResponseFromJson(Map<String, dynamic> json) =>
    LoginUserResponse(
      user: _$recordConvert(
        json['user'],
        ($jsonValue) => (
          email: $jsonValue['email'] as String?,
          firstName: $jsonValue['firstName'] as String?,
          userId: $jsonValue['userId'] as String?,
        ),
      ),
      accessToken: json['accessToken'] as String?,
    );

Map<String, dynamic> _$LoginUserResponseToJson(LoginUserResponse instance) =>
    <String, dynamic>{
      'user': <String, dynamic>{
        'email': instance.user.email,
        'firstName': instance.user.firstName,
        'userId': instance.user.userId,
      },
      'accessToken': instance.accessToken,
    };

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
