import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_server/src/app/repository/exception/update_reminder_content_exception.dart';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/prisma/generated/prisma.dart';

@Singleton(as: ReminderRepository)
final class ReminderRepositoryImpl
    with BaseRepositoryMixin
    implements ReminderRepository {
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
              remindAt: remindAt,
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
            final existing = await tx.reminder.findUnique(
              where: ReminderWhereUniqueInput(
                id: reminderId,
              ),
              include: const ReminderInclude(
                user: PrismaUnion.$1(false),
              ),
            );

            if (existing == null) {
              throw const UpdateReminderContentNotFoundException();
            }

            final updated = await tx.reminder.update(
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
            );

            if (updated == null) {
              throw const UpdateReminderContentUpdateNotFoundException();
            }

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
}
