import 'package:ribbit_server/src/prisma/generated/model.dart';

sealed class LoginUserResult {}

final class LoginUserSuccessful implements LoginUserResult {
  const LoginUserSuccessful({
    required this.accessToken,
    required this.user,
  });

  final User user;
  final String accessToken;
}

final class LoginUserFailed implements LoginUserResult {
  const LoginUserFailed();
}
