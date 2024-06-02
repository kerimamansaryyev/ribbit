import 'package:ribbit_server/src/app/repository/exception/expected_repository_exception.dart';

sealed class UpdateReminderContentException
    implements ExpectedRepositoryException {}

final class UpdateReminderContentNotFoundException
    implements UpdateReminderContentException {
  const UpdateReminderContentNotFoundException();
}
