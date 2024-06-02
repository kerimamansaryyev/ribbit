import 'package:ribbit_server/src/app/repository/reminder_repository.dart';

sealed class RescheduleReminderResult {}

final class RescheduleReminderSucceeded implements RescheduleReminderResult {
  const RescheduleReminderSucceeded({
    required this.reminder,
  });

  final ReminderRepositoryRescheduleReminderDTO reminder;
}

final class RescheduleReminderNotFound implements RescheduleReminderResult {
  const RescheduleReminderNotFound();
}
