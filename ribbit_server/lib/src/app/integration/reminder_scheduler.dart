typedef ReminderScheduleBatchHandler = void Function(
  List<int> reminderIds,
);

abstract interface class ReminderScheduler {
  void scheduleReminder({
    required int reminderId,
    required DateTime remindAt,
  });

  void cancelSchedule({
    required int reminderId,
    required DateTime remindAt,
  });

  void bindScheduleHandler({
    required ReminderScheduleBatchHandler handler,
  });

  void close();
}
