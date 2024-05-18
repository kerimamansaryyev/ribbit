import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/validate_user_credentials_result.dart';

/// User DAO
abstract interface class UserRepository {
  /// Creating users and persisting in DB
  Future<CreateUserResult> createUser({
    required String email,
    required String password,
    required String firstName,
  });

  /// Used by sign-in mostly
  Future<ValidateUserCredentialsResult> validateUserCredentials({
    required String email,
    required String password,
  });
}
