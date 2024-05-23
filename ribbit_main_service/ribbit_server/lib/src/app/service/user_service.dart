import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_user_result.dart';
import 'package:ribbit_server/src/app/service/result/login_user_result.dart';

/// Service responsible for User
abstract interface class UserService {
  /// Creating user and saving in repository
  Future<CreateUserResult> createUser({
    required String email,
    required String firstName,
    required String password,
  });

  Future<LoginUserResult> loginUser({
    required String email,
    required String password,
  });

  Future<UserRepositoryGetUserByIdDTO?> verifyFromToken({
    required String token,
  });

  Future<DeleteUserResult> deleteUserById({
    required String userId,
  });
}
