import 'package:ribbit_server/src/app/repository/exception/expected_repository_exception.dart';

sealed class DeleteReminderByIdException
    implements ExpectedRepositoryException {}

final class DeleteReminderByIdNotFoundException
    implements DeleteReminderByIdException {
  const DeleteReminderByIdNotFoundException();
}
