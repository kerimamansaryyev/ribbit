final class RibbitNotificationSchedulerServiceDelegateScheduleReminderDTO {
  const RibbitNotificationSchedulerServiceDelegateScheduleReminderDTO({
    required this.reminderId,
    required this.reminderDate,
    required this.reminderTitle,
    required this.reminderDescription,
    required this.userId,
  });

  final int reminderId;
  final DateTime reminderDate;
  final String reminderTitle;
  final String reminderDescription;
  final String userId;

  @override
  String toString() {
    return 'RibbitNotificationSchedulerServiceDelegateScheduleReminderDTO{'
        'reminderId: $reminderId, '
        'reminderDate: $reminderDate, '
        'reminderTitle: $reminderTitle, '
        'reminderDescription: $reminderDescription, '
        'userId: $userId}';
  }
}

abstract interface class RibbitNotificationSchedulerServiceDelegate {
  Future<void> scheduleReminder(
    RibbitNotificationSchedulerServiceDelegateScheduleReminderDTO reminder,
  );
  Future<void> setUserDeviceToken({
    required String userId,
    required String deviceToken,
  });
}
