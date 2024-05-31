import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/controller/extension/rest_controller_extension.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';
import 'package:ribbit_server/src/app/service/reminder_service.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/update_reminder_content_result.dart';

@singleton
final class ReminderController with BaseControllerMixin {
  const ReminderController(
    this._reminderService,
  );

  final ReminderService _reminderService;

  Future<Response> createReminder(RequestContext requestContext) async {
    return requestContext.handleAsJson<CreateReminderRequest>(
      applyInputValidators: (_, createReminderRequest) => [
        InputValidators.reminderRemindAtValidator(
          fieldName: 'remindAt',
          inputDate: createReminderRequest.remindAt,
          inputValidationPredicate: (input) =>
              input == null ||
              !DateTime.now().toLocal().isAfter(input.toLocal()),
        ),
      ],
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
          userId: getCurrentUserByRequest(context).id,
          title: title,
          notes: notes,
          remindAt: remindAt,
        )) {
          CreateReminderSuccessfullyCreated(reminder: final reminder) =>
            Response.json(
              body: CreateReminderResponse(
                reminder: (
                  reminderId: reminder.id,
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

  Future<Response> updateReminderContent(
    RequestContext requestContext,
  ) async =>
      requestContext.handleAsJson<UpdateReminderContentRequest>(
        applyInputValidators: null,
        parser: (requestContext, data) => UpdateReminderContentRequest.fromJson(
          data,
        ),
        responseDispatcher:
            (requestContext, updateReminderContentRequest) async =>
                switch (await _reminderService.updateReminderContent(
          reminderId: updateReminderContentRequest.reminderId,
          title: updateReminderContentRequest.title,
          notes: updateReminderContentRequest.notes,
        )) {
          UpdateReminderContentSucceeded(reminder: final reminder) =>
            Response.json(
              body: UpdateReminderContentResponse(
                reminder: (
                  reminderId: reminder.id,
                  title: reminder.title,
                  notes: reminder.notes,
                  userId: reminder.userId,
                  remindAt: reminder.remindAt,
                ),
              ).toJson(),
            ),
          UpdateReminderContentNotFound() => Response.json(
              statusCode: HttpStatus.notFound,
              body: const ErrorResponse(
                message: 'Reminder does not exist',
                ribbitServerErrorCode: RibbitServerErrorCode.reminderNotFound,
              ).toJson(),
            ),
          UpdateReminderContentLostUpdate() => Response.json(
              statusCode: HttpStatus.notFound,
              body: const ErrorResponse(
                message:
                    'Could not update the reminder content, it might not exist',
                ribbitServerErrorCode: RibbitServerErrorCode.reminderLostUpdate,
              ).toJson(),
            ),
        },
      );
}
