import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_server/src/app/repository/exception/delete_reminder_by_id_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/reschedule_reminder_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/update_reminder_content_exception.dart';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';
import 'package:ribbit_server/src/prisma/generated/model.dart';
import 'package:ribbit_server/src/prisma/generated/prisma.dart';

@Singleton(as: ReminderRepository)
final class ReminderRepositoryImpl
    with BaseRepositoryMixin
    implements ReminderRepository {
  static const _reminderRawTableName = 'Reminder';
  static const _reminderRawRemindAtColumnName = 'remind_at';
  static const _reminderRawIdColumnName = 'id';

  @override
  Future<ReminderRepositoryCreateReminderDTO> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
    required BaseRepositoryBeforeCommitDelegate<
            ReminderRepositoryCreateReminderDTO>
        beforeCommitHandler,
  }) =>
      preventConnectionLeak(
        () async {
          final tx = await prismaClient.$transaction.start();
          try {
            final reminder = await tx.reminder.create(
              data: PrismaUnion.$1(
                ReminderCreateInput(
                  title: title,
                  notes: notes,
                  remindAt: switch (remindAt) {
                    DateTime() => PrismaUnion.$1(remindAt),
                    null => const PrismaUnion.$2(PrismaNull()),
                  },
                  user: UserCreateNestedOneWithoutRemindersInput(
                    connect: UserWhereUniqueInput(
                      id: userId,
                    ),
                  ),
                ),
              ),
              include: const ReminderInclude(
                user: PrismaUnion.$1(false),
              ),
            );

            final successResult = (
              id: reminder.id!,
              userId: reminder.userId!,
              title: reminder.title!,
              notes: reminder.notes!,
              remindAt: reminder.remindAt,
            );

            await beforeCommitHandler(
              successResult,
            );

            await tx.$transaction.commit();

            return successResult;
          } catch (_) {
            await tx.$transaction.rollback();
            rethrow;
          }
        },
      );

  @override
  Future<ReminderRepositoryUpdateReminderContentDTO> updateReminderContent({
    required String reminderId,
    required String? title,
    required String? notes,
    required BaseRepositoryBeforeCommitDelegate<
            ReminderRepositoryCreateReminderDTO>
        beforeCommitHandler,
  }) =>
      preventConnectionLeak<ReminderRepositoryUpdateReminderContentDTO>(
        () async {
          final tx = await prismaClient.$transaction.start();

          try {
            final existing = await _getExistingReminderByIdWithoutUser(
              dbDelegate: tx.reminder,
              reminderId: reminderId,
            );

            if (existing == null) {
              throw const UpdateReminderContentNotFoundException();
            }

            final updated = (await tx.reminder.update(
              where: ReminderWhereUniqueInput(
                id: reminderId,
              ),
              data: PrismaUnion.$1(
                ReminderUpdateInput(
                  title: PrismaUnion.$1(title ?? existing.title ?? ''),
                  notes: PrismaUnion.$1(notes ?? existing.notes ?? ''),
                ),
              ),
              include: const ReminderInclude(
                user: PrismaUnion.$1(false),
              ),
            ))!;

            final result = (
              id: updated.id!,
              userId: updated.userId!,
              title: updated.title!,
              notes: updated.notes!,
              remindAt: updated.remindAt,
            );

            await beforeCommitHandler(result);

            await tx.$transaction.commit();

            return result;
          } catch (_) {
            await tx.$transaction.rollback();
            rethrow;
          }
        },
      );

  @override
  Future<ReminderRepositoryRescheduleReminderDTO> rescheduleReminder({
    required String reminderId,
    required DateTime? newDate,
    required BaseRepositoryBeforeCommitDelegate<
            ReminderRepositoryCreateReminderDTO>
        beforeCommitHandler,
  }) =>
      preventConnectionLeak(() async {
        final tx = await prismaClient.$transaction.start();
        try {
          final existing = await _getExistingReminderByIdWithoutUser(
            dbDelegate: tx.reminder,
            reminderId: reminderId,
          );

          if (existing == null) {
            throw const RescheduleReminderNotFoundException();
          }

          await _mySQLQueryToUpdateRemindAt(
            reminderId: reminderId,
            newDate: newDate,
            intermediateClient: tx,
          );

          final updated = (await _getExistingReminderByIdWithoutUser(
            dbDelegate: tx.reminder,
            reminderId: reminderId,
          ))!;

          final result = (
            id: updated.id!,
            userId: updated.userId!,
            title: updated.title!,
            notes: updated.notes!,
            remindAt: updated.remindAt,
          );

          await beforeCommitHandler(result);

          await tx.$transaction.commit();

          return result;
        } catch (_) {
          await tx.$transaction.rollback();
          rethrow;
        }
      });

  @override
  Future<void> deleteReminderById({
    required String reminderId,
    required BaseRepositoryBeforeCommitDelegate<String> beforeCommitHandler,
  }) =>
      preventConnectionLeak(() async {
        final tx = await prismaClient.$transaction.start();
        try {
          final existing = await _getExistingReminderByIdWithoutUser(
            dbDelegate: tx.reminder,
            reminderId: reminderId,
          );
          final existingReminderId = existing?.id;
          if (existingReminderId == null) {
            throw const DeleteReminderByIdNotFoundException();
          }

          await tx.reminder.delete(
            where: ReminderWhereUniqueInput(
              id: existingReminderId,
            ),
          );
          await beforeCommitHandler(existingReminderId);
          await tx.$transaction.commit();
        } catch (_) {
          await tx.$transaction.rollback();
          rethrow;
        }
      });

  Future<Reminder?> _getExistingReminderByIdWithoutUser({
    required ReminderDelegate dbDelegate,
    required String reminderId,
  }) {
    return dbDelegate.findUnique(
      where: ReminderWhereUniqueInput(
        id: reminderId,
      ),
      include: const ReminderInclude(
        user: PrismaUnion.$1(false),
      ),
    );
  }

  /// Needed because there is an error in Dart Prisma ORM which makes it
  /// impossible to set remind_at to null
  static Future<void> _mySQLQueryToUpdateRemindAt({
    required String reminderId,
    required DateTime? newDate,
    required PrismaClient intermediateClient,
  }) async {
    const query = 'UPDATE '
        ' `$_reminderRawTableName` '
        ' SET `$_reminderRawRemindAtColumnName` = ? '
        ' WHERE `$_reminderRawIdColumnName` = ?';
    await intermediateClient.$raw.execute(query, [
      newDate,
      reminderId,
    ]);
  }
}
