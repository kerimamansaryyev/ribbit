import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';
import 'package:ribbit_server/src/app/controller/reminder_controller.dart';
import 'package:ribbit_server/src/injectable_config/di_init.dart';

FutureOr<Response> onRequest(RequestContext context) =>
    switch (context.request.method) {
      HttpMethod.patch =>
        appServiceLocator<ReminderController>().updateReminderContent(context),
      _ => Future.value(
          ErrorResponseFactory.invalidRequestMethod(),
        ),
    };
