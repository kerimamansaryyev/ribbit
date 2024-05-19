import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';

Handler middleware(Handler handler) => handler
    .use(requestLogger())
    .use(BaseControllerMixin.authenticationMiddleWare)
    .use(BaseControllerMixin.unexpectedErrorResponseMiddleware);
