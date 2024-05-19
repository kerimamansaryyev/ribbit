import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';
import 'package:ribbit_server/src/app/service/reminder_service.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
import 'package:ribbit_server/src/prisma/generated/model.dart';

@singleton
final class ReminderController with BaseControllerMixin {
  const ReminderController(
    this._reminderService,
  );

  final ReminderService _reminderService;

  Future<Response> createReminder(RequestContext requestContext) async {
    final String title;
    final String notes;
    final DateTime? remindAt;

    try {
      final createUserRequest = CreateReminderRequest.fromJson(
        await requestContext.request.json() as Map<String, dynamic>,
      );
      (title, notes, remindAt) = (
        createUserRequest.title,
        createUserRequest.notes,
        createUserRequest.remindAt,
      );
    } catch (ex) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.invalidRequestFormat,
          message: 'Bad request: $ex',
        ).toJson(),
      );
    }

    return resilientResponse(
      () async => switch (await _reminderService.createReminder(
        userId: requestContext.read<User>().id!,
        title: title,
        notes: notes,
        remindAt: remindAt,
      )) {
        CreateReminderInvalidInput(fieldName: final fieldName) => Response.json(
            statusCode: HttpStatus.badRequest,
            body: ErrorResponse(
              message: 'Invalid input on field: $fieldName',
              ribbitServerErrorCode: RibbitServerErrorCode.invalidInput,
            ).toJson(),
          ),
        CreateReminderSuccessfullyCreated(reminder: final reminder) =>
          Response.json(
            body: CreateReminderResponse(
              reminder: (
                title: reminder.title,
                notes: reminder.notes,
                userId: reminder.userId,
                remindAt: reminder.remindAt,
              ),
            ).toJson(),
          ),
      },
    );
  }
}
