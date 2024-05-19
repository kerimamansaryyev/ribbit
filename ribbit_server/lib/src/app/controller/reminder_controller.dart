import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/controller/extension/rest_controller_extension.dart';
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
    return requestContext.handleAsJson<CreateReminderRequest>(
      parser: (context, rawData) => CreateReminderRequest.fromJson(
        rawData,
      ),
      responseDispatcher: (context, createReminderRequest) async {
        final (title, notes, remindAt) = (
          createReminderRequest.title,
          createReminderRequest.notes,
          createReminderRequest.remindAt,
        );

        return switch (await _reminderService.createReminder(
          userId: requestContext.read<User>().id!,
          title: title,
          notes: notes,
          remindAt: remindAt,
        )) {
          CreateReminderInvalidInput(fieldName: final fieldName) =>
            Response.json(
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
        };
      },
    );
  }
}
