import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';
import 'package:ribbit_server/src/injectable_config/di_init.dart';
import 'package:ribbit_server/src/prisma/generated/model.dart';

typedef AuthenticationMiddleWareAuthenticator = Future<User?> Function(
  String token,
);
typedef RequestHandler = FutureOr<Response> Function(RequestContext context);
typedef RequestHandlerPerMethod = Map<HttpMethod, RequestHandler>;

abstract final class ErrorResponseFactory {
  static Response unexpected() => Response.json(
        statusCode: HttpStatus.internalServerError,
        body: const ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.unexpectedError,
          message: 'Unexpected Error',
        ).toJson(),
      );

  static Response unauthorized() => Response.json(
        statusCode: HttpStatus.unauthorized,
        body: const ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.unauthorized,
          message: 'Unauthorized',
        ),
      );

  static Response invalidRequestFormat(dynamic exception) => Response.json(
        statusCode: HttpStatus.badRequest,
        body: ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.invalidRequestFormat,
          message: 'Bad request: $exception',
        ).toJson(),
      );

  static Response invalidRequestMethod() => invalidRequestFormat(
        'Invalid request method',
      );

  static Response invalidInput(
    String inputFieldName,
  ) =>
      Response.json(
        statusCode: HttpStatus.badRequest,
        body: ErrorResponse(
          message: 'Invalid input on field: $inputFieldName',
          ribbitServerErrorCode: RibbitServerErrorCode.invalidInput,
        ).toJson(),
      );
}

mixin BaseControllerMixin {
  @protected
  UserRepositoryGetUserByIdDTO getCurrentUserByRequest(
    RequestContext context,
  ) =>
      context.read<UserRepositoryGetUserByIdDTO>();

  static FutureOr<Response> allowRequestHandlerPerRequestMethod(
    RequestContext context, {
    required RequestHandlerPerMethod handlers,
  }) =>
      handlers[context.request.method]?.call(context) ??
      ErrorResponseFactory.invalidRequestMethod();

  static InputValidator<dynamic>? validateInputs(
    List<InputValidator<dynamic>> validators,
  ) {
    for (final validator in validators) {
      if (!validator.isValid()) {
        return validator;
      }
    }
    return null;
  }

  static Handler authenticationMiddleWare(Handler handler) =>
      (requestContext) async {
        final authorization = requestContext.request.headers.bearer();
        if (authorization != null) {
          final user = await appServiceLocator<UserService>().verifyFromToken(
            token: authorization,
          );

          if (user != null) {
            return handler(
              requestContext.provide<UserRepositoryGetUserByIdDTO>(
                () => user,
              ),
            );
          }
        }

        return ErrorResponseFactory.unauthorized();
      };

  static Handler unexpectedErrorResponseMiddleware(Handler handler) =>
      (requestContext) async {
        try {
          return await handler(requestContext);
        } catch (ex, trace) {
          appServiceLocator<Logger>().f(
            'Unexpected Error\nEndpoint:${requestContext.request.uri}',
            error: ex,
            stackTrace: trace,
          );
          return ErrorResponseFactory.unexpected();
        }
      };
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
