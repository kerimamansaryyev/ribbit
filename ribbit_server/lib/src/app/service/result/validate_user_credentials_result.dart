import 'package:ribbit_server/src/prisma/generated/model.dart';

sealed class ValidateUserCredentialsResult {}

final class ValidateUserCredentialsSucceeded
    implements ValidateUserCredentialsResult {
  const ValidateUserCredentialsSucceeded({
    required this.user,
  });

  final User user;
}

final class ValidateUserCredentialsNotValid
    implements ValidateUserCredentialsResult {
  const ValidateUserCredentialsNotValid();
}
