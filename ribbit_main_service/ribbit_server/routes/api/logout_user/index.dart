import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_server/src/app/controller/user_controller.dart';
import 'package:ribbit_server/src/injectable_config/di_init.dart';

FutureOr<Response> onRequest(RequestContext context) =>
    appServiceLocator<UserController>().logout(context);
