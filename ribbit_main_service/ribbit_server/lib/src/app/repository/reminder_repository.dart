import 'dart:async';

import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';

typedef ReminderRepositoryCreateReminderDTO = ({
  int id,
  String userId,
  String title,
  String notes,
  DateTime? remindAt,
});

typedef ReminderRepositoryBeforeCommitDelegate<T> = FutureOr<void> Function(
  T entity,
);

abstract interface class ReminderRepository {
  Future<CreateReminderResult> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
    required BaseRepositoryBeforeCommitDelegate<
            ReminderRepositoryCreateReminderDTO>
        beforeCommitHandler,
  });
}
