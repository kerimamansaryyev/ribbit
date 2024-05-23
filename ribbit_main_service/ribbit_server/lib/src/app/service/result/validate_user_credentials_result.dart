import 'package:ribbit_server/src/app/repository/user_repository.dart';

sealed class ValidateUserCredentialsResult {}

final class ValidateUserCredentialsSucceeded
    implements ValidateUserCredentialsResult {
  const ValidateUserCredentialsSucceeded({
    required this.user,
  });

  final UserRepositoryValidateUserCredentialsDTO user;
}

final class ValidateUserCredentialsNotValid
    implements ValidateUserCredentialsResult {
  const ValidateUserCredentialsNotValid();
}
