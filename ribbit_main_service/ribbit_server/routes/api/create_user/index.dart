import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';
import 'package:ribbit_server/src/app/controller/user_controller.dart';
import 'package:ribbit_server/src/injectable_config/di_init.dart';

RequestHandlerPerMethod? _handlerPerMethod;

FutureOr<Response> onRequest(RequestContext context) =>
    BaseControllerMixin.allowRequestHandlerPerRequestMethod(
      context,
      handlers: _handlerPerMethod ??= {
        HttpMethod.post: appServiceLocator.get<UserController>().createUser,
      },
    );
