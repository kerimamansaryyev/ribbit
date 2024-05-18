import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_user_result.dart';
import 'package:ribbit_server/src/app/service/result/validate_user_credentials_result.dart';
import 'package:ribbit_server/src/prisma/generated/model.dart';

/// User DAO
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

  Future<User?> getUserByUserId({
    required String userId,
  });

  Future<DeleteUserResult> deleteUserById({
    required String userId,
  });
}
