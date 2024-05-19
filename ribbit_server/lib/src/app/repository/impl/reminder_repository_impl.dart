import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
import 'package:ribbit_server/src/prisma/generated/model.dart';
import 'package:ribbit_server/src/prisma/generated/prisma.dart';

@Singleton(as: ReminderRepository)
final class ReminderRepositoryImpl
    with BaseRepositoryMixin
    implements ReminderRepository {
  @override
  Future<CreateReminderResult> createReminder({
    required String userId,
    required String title,
    required String notes,
    required DateTime? remindAt,
  }) =>
      preventConnectionLeak(
        () async {
          final invalidInput = validateInputs(
            [
              InputValidators.reminderRemindAtValidator(
                remindAt,
              ),
            ],
          );
          if (invalidInput != null) {
            return CreateReminderInvalidInput(
              fieldName: invalidInput.fieldName,
            );
          }

          return CreateReminderSuccessfullyCreated(
            reminder: await prismaClient.reminder.create(
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
            ),
          );
        },
      );

  @override
  Future<Iterable<Reminder>> getAllRemindersAfterNow() => preventConnectionLeak(
        () async => prismaClient.reminder.findMany(
          where: ReminderWhereInput(
            NOT: const PrismaUnion.$1(
              ReminderWhereInput(
                remindAt: PrismaUnion.$2(
                  PrismaUnion.$2(
                    PrismaNull(),
                  ),
                ),
              ),
            ),
            remindAt: PrismaUnion.$1(
              DateTimeNullableFilter(
                gt: PrismaUnion.$1(
                  DateTime.now(),
                ),
              ),
            ),
          ),
          select: const ReminderSelect(
            id: true,
            remindAt: true,
          ),
        ),
      );
}
