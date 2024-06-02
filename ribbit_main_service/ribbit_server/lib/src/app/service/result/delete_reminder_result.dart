sealed class DeleteReminderResult {}

final class DeleteReminderSucceeded implements DeleteReminderResult {
  const DeleteReminderSucceeded();
}

final class DeleteReminderNotFound implements DeleteReminderResult {
  const DeleteReminderNotFound();
}
