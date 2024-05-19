import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/integration/reminder_scheduler.dart';

/// In memory scheduler
@Singleton(
  as: ReminderScheduler,
)
final class ReminderSchedulerImpl implements ReminderScheduler {
  ReminderScheduleBatchHandler? _batchHandler;

  final _schedules = <String, Set<int>>{};

  Timer? _timer;

  @override
  void bindScheduleHandler({
    required ReminderScheduleBatchHandler handler,
  }) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _fireBatch());
    _batchHandler = handler;
  }

  @override
  void scheduleReminder({
    required int reminderId,
    required DateTime remindAt,
  }) {
    remindAt = remindAt.toLocal();

    final now = DateTime.now();

    if (!now.isBefore(remindAt)) {
      return;
    }

    (_schedules[_hashDateTime(remindAt)] ??= <int>{}).add(
      reminderId,
    );
  }

  void _fireBatch() {
    final key = _getNowHashed();

    final batch = [...?_schedules[key]];
    _schedules.remove(key);
    _batchHandler?.call(batch);
  }

  String _hashDateTime(DateTime dateTime) {
    final (year, month, day, hour, minute) = (
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    return '$year$month$day$hour$minute';
  }

  String _getNowHashed() => _hashDateTime(
        DateTime.now(),
      );

  @override
  void close() => _timer?.cancel();

  @override
  void cancelSchedule({
    required int reminderId,
    required DateTime remindAt,
  }) =>
      _schedules[_hashDateTime(remindAt)]?.remove(
        reminderId,
      );
}
