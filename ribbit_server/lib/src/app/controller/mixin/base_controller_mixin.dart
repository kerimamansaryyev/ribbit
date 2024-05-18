import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';
import 'package:ribbit_server/src/injectable_config/di_init.dart';
import 'package:ribbit_server/src/prisma/generated/model.dart';

typedef ResponsePerformer = Future<Response> Function();
typedef AuthenticationMiddleWareAuthenticator = Future<User?> Function(
  String token,
);

mixin BaseControllerMixin {
  Future<Response> resilientResponse(
      ResponsePerformer responsePerformer) async {
    try {
      return await responsePerformer();
    } catch (ex) {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: const ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.unexpectedError,
          message: 'Unexpected Error',
        ).toJson(),
      );
    }
  }

  static Handler authenticationMiddleWare(Handler handler) => handler.use(
        (handler) => (requestContext) async {
          final authorization = requestContext.request.headers.bearer();
          if (authorization != null) {
            final user = await appServiceLocator<UserService>().verifyFromToken(
              token: authorization,
            );

            if (user != null) {
              return handler(requestContext.provide(() => user));
            }
          }

          return Response.json(
            statusCode: HttpStatus.unauthorized,
            body: const ErrorResponse(
              ribbitServerErrorCode: RibbitServerErrorCode.unauthorized,
              message: 'Unauthorized',
            ),
          );
        },
      );
}

extension _HeadersExtension on Map<String, String> {
  String? authorization(String type) {
    final value = this['Authorization']?.split(' ');

    if (value != null && value.length == 2 && value.first == type) {
      return value.last;
    }

    return null;
  }

  String? bearer() => authorization('Bearer');
}
