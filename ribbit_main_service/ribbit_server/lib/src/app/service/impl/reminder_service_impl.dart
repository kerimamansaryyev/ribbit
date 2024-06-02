import 'dart:math' as math;
import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/integration/ribbit_notification_scheduler_service_delegate.dart';
import 'package:ribbit_server/src/app/repository/exception/delete_reminder_by_id_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/reschedule_reminder_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/update_reminder_content_exception.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/app/service/reminder_service.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/reschedule_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/update_reminder_content_result.dart';

typedef _ScheduleReminderDTO = ({
  String id,
  String userId,
  String title,
  String notes,
  DateTime? remindAt,
});

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

  @override
  Future<UpdateReminderContentResult> updateReminderContent({
    required String reminderId,
    required String? title,
    required String? notes,
  }) async {
    try {
      return UpdateReminderContentSucceeded(
        reminder: await _reminderRepository.updateReminderContent(
          reminderId: reminderId,
          title: title,
          notes: notes,
          beforeCommitHandler: _scheduleReminder,
        ),
      );
    } on UpdateReminderContentException catch (ex) {
      switch (ex) {
        case UpdateReminderContentNotFoundException():
          return const UpdateReminderContentNotFound();
      }
    }
  }

  @override
  Future<RescheduleReminderResult> rescheduleReminder({
    required String reminderId,
    required DateTime? newDate,
  }) async {
    try {
      return RescheduleReminderSucceeded(
        reminder: await _reminderRepository.rescheduleReminder(
          reminderId: reminderId,
          newDate: newDate,
          beforeCommitHandler: newDate == null
              ? (dto) => _cancelReminder(dto.id)
              : _scheduleReminder,
        ),
      );
    } on RescheduleReminderException catch (ex) {
      switch (ex) {
        case RescheduleReminderNotFoundException():
          return const RescheduleReminderNotFound();
      }
    }
  }

  @override
  Future<DeleteReminderResult> deleteReminder({
    required String reminderId,
  }) async {
    try {
      await _reminderRepository.deleteReminderById(
        reminderId: reminderId,
        beforeCommitHandler: _cancelReminder,
      );
      return const DeleteReminderSucceeded();
    } on DeleteReminderByIdException catch (ex) {
      switch (ex) {
        case DeleteReminderByIdNotFoundException():
          return const DeleteReminderNotFound();
      }
    }
  }

  Future<void> _cancelReminder(String reminderId) =>
      _schedulerServiceDelegate.cancelReminder(
        reminderId: reminderId,
      );

  Future<void> _scheduleReminder(
    _ScheduleReminderDTO reminder,
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
