import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/reschedule_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/update_reminder_content_result.dart';

abstract interface class ReminderService {
  Future<CreateReminderResult> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
  });

  Future<UpdateReminderContentResult> updateReminderContent({
    required String reminderId,
    required String? title,
    required String? notes,
  });

  Future<RescheduleReminderResult> rescheduleReminder({
    required String reminderId,
    required DateTime? newDate,
  });

  Future<DeleteReminderResult> deleteReminder({
    required String reminderId,
  });
}
