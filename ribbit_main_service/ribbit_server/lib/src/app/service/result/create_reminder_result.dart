import 'package:ribbit_server/src/app/repository/reminder_repository.dart';

sealed class CreateReminderResult {}

final class CreateReminderInvalidInput implements CreateReminderResult {
  const CreateReminderInvalidInput({
    required this.fieldName,
  });

  final String fieldName;
}

final class CreateReminderSuccessfullyCreated implements CreateReminderResult {
  const CreateReminderSuccessfullyCreated({
    required this.reminder,
  });

  final ReminderRepositoryCreateReminderDTO reminder;
}
