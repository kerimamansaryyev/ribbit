import 'package:ribbit_server/src/app/repository/result/create_user_result.dart';

/// User DAO
abstract interface class UserRepository {
  /// Creating users and persisting in DB
  Future<CreateUserResult> createUser({
    required String email,
    required String password,
    required String firstName,
  });
}
