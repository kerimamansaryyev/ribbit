import 'package:ribbit_server/src/app/repository/exception/expected_repository_exception.dart';

sealed class RescheduleReminderException
    implements ExpectedRepositoryException {}

final class RescheduleReminderNotFoundException
    implements RescheduleReminderException {
  const RescheduleReminderNotFoundException();
}
