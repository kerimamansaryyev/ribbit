import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/controller/extension/rest_controller_extension.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';
import 'package:ribbit_server/src/app/service/reminder_service.dart';
import 'package:ribbit_server/src/app/service/result/create_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_reminder_result.dart';
import 'package:ribbit_server/src/app/service/result/reschedule_reminder_result.dart';
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
          UpdateReminderContentNotFound() => _reminderNotFoundResponse(),
        },
      );

  Future<Response> rescheduleReminder(RequestContext requestContext) =>
      requestContext.handleAsJson<RescheduleReminderRequest>(
        applyInputValidators: null,
        parser: (_, data) => RescheduleReminderRequest.fromJson(data),
        responseDispatcher: (requestContext, rescheduleReminderRequest) async =>
            switch (await _reminderService.rescheduleReminder(
          reminderId: rescheduleReminderRequest.reminderId,
          newDate: rescheduleReminderRequest.newDate,
        )) {
          RescheduleReminderSucceeded(reminder: final reminder) =>
            Response.json(
              body: RescheduleReminderResponse(
                reminder: (
                  title: reminder.title,
                  reminderId: reminder.id,
                  userId: reminder.userId,
                  notes: reminder.notes,
                  remindAt: reminder.remindAt,
                ),
              ).toJson(),
            ),
          RescheduleReminderNotFound() => _reminderNotFoundResponse(),
        },
      );

  Future<Response> deleteReminder(RequestContext requestContext) =>
      requestContext.handleAsJson<DeleteReminderRequest>(
        applyInputValidators: null,
        parser: (_, data) => DeleteReminderRequest.fromJson(data),
        responseDispatcher: (requestContext, deleteReminderRequest) async =>
            switch (await _reminderService.deleteReminder(
          reminderId: deleteReminderRequest.reminderId,
        )) {
          DeleteReminderSucceeded() => Response.json(
              body: const DeleteReminderResponse(
                message: 'Reminder has successfully been deleted',
              ).toJson(),
            ),
          DeleteReminderNotFound() => _reminderNotFoundResponse(),
        },
      );

  static Response _reminderNotFoundResponse() => Response.json(
        statusCode: HttpStatus.notFound,
        body: const ErrorResponse(
          message: 'Reminder does not exist',
          ribbitServerErrorCode: RibbitServerErrorCode.reminderNotFound,
        ).toJson(),
      );
}
