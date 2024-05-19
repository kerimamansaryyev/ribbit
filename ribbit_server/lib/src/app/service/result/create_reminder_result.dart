import 'package:ribbit_server/src/prisma/generated/model.dart';

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

  final Reminder reminder;
}
