import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/integration/reminder_scheduler.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/app/service/reminder_service.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
import 'package:ribbit_server/src/prisma/generated/model.dart';

@Singleton(as: ReminderService)
final class ReminderServiceImpl implements ReminderService {
  const ReminderServiceImpl(
    this._reminderRepository,
    this._reminderScheduler,
  );

  final ReminderRepository _reminderRepository;
  final ReminderScheduler _reminderScheduler;

  @postConstruct
  void init() {
    _bootReminderScheduler();
  }

  @override
  Future<CreateReminderResult> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
  }) async {
    final result = await _reminderRepository.createReminder(
      userId: userId,
      title: title,
      notes: notes,
      remindAt: remindAt,
    );

    if (result
        case CreateReminderSuccessfullyCreated(reminder: final reminder)) {
      _scheduleReminder(reminder);
    }

    return result;
  }

  void _onRemindersBatchFired(List<int> reminderIds) {}

  void _scheduleReminder(Reminder reminder) {
    final (reminderId, remindAt) = (reminder.id, reminder.remindAt);
    if (reminderId == null || remindAt == null) {
      return;
    }
    _reminderScheduler.scheduleReminder(
      reminderId: reminderId,
      remindAt: remindAt,
    );
  }

  Future<void> _bootReminderScheduler() async {
    _reminderScheduler.bindScheduleHandler(
      handler: _onRemindersBatchFired,
    );
    final reminders = await _reminderRepository.getAllRemindersAfterNow();
    reminders.forEach(_scheduleReminder);
  }
}
