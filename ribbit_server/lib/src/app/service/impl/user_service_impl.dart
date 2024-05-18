import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/integration/jwt_authenticator.dart';
import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/login_user_result.dart';
import 'package:ribbit_server/src/app/service/result/validate_user_credentials_result.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';

@Singleton(as: UserService)
final class UserServiceImpl implements UserService {
  const UserServiceImpl(
    this._jwtAuthenticator,
    this._userRepository,
  );

  final UserRepository _userRepository;
  final JWTAuthenticator _jwtAuthenticator;

  @override
  Future<CreateUserResult> createUser({
    required String email,
    required String firstName,
    required String password,
  }) =>
      _userRepository.createUser(
        email: email,
        password: password,
        firstName: firstName,
      );

  @override
  Future<LoginUserResult> loginUser({
    required String email,
    required String password,
  }) async {
    return switch (await _userRepository.validateUserCredentials(
      email: email,
      password: password,
    )) {
      ValidateUserCredentialsSucceeded(user: final user) => LoginUserSuccessful(
          user: user,
          accessToken: _jwtAuthenticator.generateToken(
            userId: user.id!,
            email: email,
          ),
        ),
      ValidateUserCredentialsNotValid() => const LoginUserFailed(),
    };
  }
}
