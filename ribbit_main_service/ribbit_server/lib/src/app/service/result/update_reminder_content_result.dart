import 'package:ribbit_server/src/app/repository/reminder_repository.dart';

sealed class UpdateReminderContentResult {}

final class UpdateReminderContentSucceeded
    implements UpdateReminderContentResult {
  const UpdateReminderContentSucceeded({
    required this.reminder,
  });

  final ReminderRepositoryUpdateReminderContentDTO reminder;
}

final class UpdateReminderContentNotFound
    implements UpdateReminderContentResult {
  const UpdateReminderContentNotFound();
}

final class UpdateReminderContentLostUpdate
    implements UpdateReminderContentResult {
  const UpdateReminderContentLostUpdate();
}
