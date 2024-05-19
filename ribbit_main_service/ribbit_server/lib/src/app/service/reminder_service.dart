import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';

abstract interface class ReminderService {
  Future<CreateReminderResult> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
  });
}
