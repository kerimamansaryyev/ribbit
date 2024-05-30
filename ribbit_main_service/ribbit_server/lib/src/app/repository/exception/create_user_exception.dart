import 'package:ribbit_server/src/app/repository/exception/expected_repository_exception.dart';

sealed class CreateUserException implements ExpectedRepositoryException {}

final class CreateUserAlreadyExistsException implements CreateUserException {
  const CreateUserAlreadyExistsException();
}
