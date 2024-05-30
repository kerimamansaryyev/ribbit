import 'package:ribbit_server/src/app/repository/exception/expected_repository_exception.dart';

sealed class DeleteUserByIdException implements ExpectedRepositoryException {}

final class DeleteUserByIdNotFoundException implements DeleteUserByIdException {
  const DeleteUserByIdNotFoundException();
}
