import 'dart:async';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';

typedef ReminderRepositoryCreateReminderDTO = ({
  String id,
  String userId,
  String title,
  String notes,
  DateTime? remindAt,
});

typedef ReminderRepositoryUpdateReminderContentDTO = ({
  String id,
  String userId,
  String title,
  String notes,
  DateTime? remindAt,
});

typedef ReminderRepositoryBeforeCommitDelegate<T> = FutureOr<void> Function(
  T entity,
);

abstract interface class ReminderRepository {
  Future<ReminderRepositoryCreateReminderDTO> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
    required BaseRepositoryBeforeCommitDelegate<
            ReminderRepositoryCreateReminderDTO>
        beforeCommitHandler,
  });

  Future<ReminderRepositoryUpdateReminderContentDTO> updateReminderContent({
    required String reminderId,
    required String? title,
    required String? notes,
    required BaseRepositoryBeforeCommitDelegate<
            ReminderRepositoryCreateReminderDTO>
        beforeCommitHandler,
  });
}
