import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_server/src/app/input_validator/input_validator.dart';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/reminder_repository.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
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
              _remindAtValidator(
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
                  user: UserCreateNestedOneWithoutRemindersInput(
                    connect: UserWhereUniqueInput(
                      id: userId,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

  InputValidator<DateTime?> _remindAtValidator(DateTime? date) =>
      InputValidator(
        fieldName: 'remind_at',
        inputValidatorPredicate: (input) {
          if (input == null) return true;

          final now = DateTime.now();

          return !now.isAfter(input);
        },
        input: date,
      );
}
