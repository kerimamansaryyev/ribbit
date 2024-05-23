import 'package:ribbit_server/src/app/repository/user_repository.dart';

sealed class LoginUserResult {}

final class LoginUserSuccessful implements LoginUserResult {
  const LoginUserSuccessful({
    required this.accessToken,
    required this.user,
  });

  final UserRepositoryValidateUserCredentialsDTO user;
  final String accessToken;
}

final class LoginUserFailed implements LoginUserResult {
  const LoginUserFailed();
}
