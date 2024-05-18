import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/repository/result/create_user_result.dart';
import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';

/// Implementation of [UserService]
@Singleton(as: UserService)
final class UserServiceImpl implements UserService {
  /// Injecting User DAO
  const UserServiceImpl({
    required this.userRepository,
  });

  /// Using as User DAO
  final UserRepository userRepository;

  @override
  Future<CreateUserResult> createUser({
    required String email,
    required String firstName,
    required String password,
  }) =>
      userRepository.createUser(
        email: email,
        password: password,
        firstName: firstName,
      );
}
