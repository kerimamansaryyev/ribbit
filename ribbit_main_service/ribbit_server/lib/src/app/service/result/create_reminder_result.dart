import 'package:ribbit_server/src/app/repository/reminder_repository.dart';

sealed class CreateReminderResult {}

final class CreateReminderSuccessfullyCreated implements CreateReminderResult {
  const CreateReminderSuccessfullyCreated({
    required this.reminder,
  });

  final ReminderRepositoryCreateReminderDTO reminder;
}
