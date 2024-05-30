import 'package:ribbit_server/src/app/repository/exception/expected_repository_exception.dart';

sealed class ValidateUserCredentialsException
    implements ExpectedRepositoryException {}

final class ValidateUserCredentialsInvalidException
    implements ValidateUserCredentialsException {
  const ValidateUserCredentialsInvalidException();
}
