import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_user_result.dart';
import 'package:ribbit_server/src/app/service/result/validate_user_credentials_result.dart';

typedef UserRepositoryCreateUserDTO = ({
  String id,
  String email,
  String firstName,
});

typedef UserRepositoryValidateUserCredentialsDTO = ({
  String id,
  String email,
  String firstName,
});

final class UserRepositoryGetUserByIdDTO {
  const UserRepositoryGetUserByIdDTO({
    required this.firstName,
    required this.email,
    required this.id,
  });

  final String id;
  final String email;
  final String firstName;
}

abstract interface class UserRepository {
  Future<CreateUserResult> createUser({
    required String email,
    required String password,
    required String firstName,
  });

  Future<ValidateUserCredentialsResult> validateUserCredentials({
    required String email,
    required String password,
  });

  Future<UserRepositoryGetUserByIdDTO?> getUserByUserId({
    required String userId,
  });

  Future<DeleteUserResult> deleteUserById({
    required String userId,
  });
}
