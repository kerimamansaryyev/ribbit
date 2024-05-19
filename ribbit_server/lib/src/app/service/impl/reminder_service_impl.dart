import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/app/service/reminder_service.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';

@Singleton(as: ReminderService)
final class ReminderServiceImpl implements ReminderService {
  const ReminderServiceImpl(
    this._reminderRepository,
  );

  final ReminderRepository _reminderRepository;

  @override
  Future<CreateReminderResult> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
  }) =>
      _reminderRepository.createReminder(
        userId: userId,
        title: title,
        notes: notes,
        remindAt: remindAt,
      );
}
