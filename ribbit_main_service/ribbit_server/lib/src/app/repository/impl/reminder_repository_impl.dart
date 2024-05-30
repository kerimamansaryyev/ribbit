import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
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
}
