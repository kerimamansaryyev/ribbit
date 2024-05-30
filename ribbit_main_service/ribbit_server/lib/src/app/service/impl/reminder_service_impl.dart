import 'dart:math' as math;
import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/integration/ribbit_notification_scheduler_service_delegate.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/app/service/reminder_service.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';

@Singleton(as: ReminderService)
final class ReminderServiceImpl implements ReminderService {
  const ReminderServiceImpl(
    this._reminderRepository,
    this._schedulerServiceDelegate,
  );

  static const _maxNotificationBodyLength = 100;

  final ReminderRepository _reminderRepository;
  final RibbitNotificationSchedulerServiceDelegate _schedulerServiceDelegate;

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
      beforeCommitHandler: _scheduleReminder,
    );

    return CreateReminderSuccessfullyCreated(
      reminder: result,
    );
  }

  Future<void> _scheduleReminder(
    ReminderRepositoryCreateReminderDTO reminder,
  ) async {
    final remindAt = reminder.remindAt;

    if (remindAt == null) {
      return;
    }

    return _schedulerServiceDelegate.scheduleReminder(
      RibbitNotificationSchedulerServiceDelegateScheduleReminderDTO(
        reminderId: reminder.id,
        reminderDate: remindAt,
        reminderTitle: reminder.title,
        reminderDescription: _reminderNotesTransform(reminder.notes),
        userId: reminder.userId,
      ),
    );
  }

  String _reminderNotesTransform(String reminderNotes) {
    final length = reminderNotes.length;
    return '${reminderNotes.substring(
      0,
      math.min(length, _maxNotificationBodyLength),
    )}'
        '...';
  }
}
