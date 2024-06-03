// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) =>
    CreateUserResponse(
      user: _$recordConvert(
        json['user'],
        ($jsonValue) => (
          email: $jsonValue['email'] as String?,
          userId: $jsonValue['userId'] as String?,
        ),
      ),
    );

Map<String, dynamic> _$CreateUserResponseToJson(CreateUserResponse instance) =>
    <String, dynamic>{
      'user': <String, dynamic>{
        'email': instance.user.email,
        'userId': instance.user.userId,
      },
    };

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
