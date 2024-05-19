import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';

Handler middleware(Handler handler) =>
    BaseControllerMixin.authenticationMiddleWare(
      handler,
    );
