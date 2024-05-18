import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';
import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/login_user_result.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';

/// Handling requests upon User
@Singleton()
final class UserController with BaseControllerMixin {
  /// Injecting dependencies
  const UserController(this._userService);

  /// Using injected UserService for CRUD
  final UserService _userService;

  /// Creates User
  Future<Response> createUser(
    RequestContext requestContext,
  ) async {
    final String email;
    final String firstName;
    final String password;

    try {
      final createUserRequest = CreateUserRequest.fromJson(
        await requestContext.request.json() as Map<String, dynamic>,
      );
      (email, firstName, password) = (
        createUserRequest.email,
        createUserRequest.firstName,
        createUserRequest.password,
      );
    } catch (ex) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.invalidRequestFormat,
          message: 'Bad request: $ex',
        ).toJson(),
      );
    }

    return resilientResponse(() async {
      final result = await _userService.createUser(
        email: email,
        firstName: firstName,
        password: password,
      );

      return switch (result) {
        CreateUserAlreadyExists() => Response.json(
            statusCode: HttpStatus.forbidden,
            body: const ErrorResponse(
              message: 'User already exists',
              ribbitServerErrorCode: RibbitServerErrorCode.userAlreadyExists,
            ).toJson(),
          ),
        CreateUserSuccessfullyCreated(user: final user) => Response.json(
            body: CreateUserResponse(
              user: (
                firstName: user.firstName,
                email: user.email,
                userId: user.id,
              ),
            ).toJson(),
          ),
      };
    });
  }

  Future<Response> loginUser(
    RequestContext requestContext,
  ) async {
    final String email;
    final String password;

    try {
      final createUserRequest = LoginUserRequest.fromJson(
        await requestContext.request.json() as Map<String, dynamic>,
      );
      (email, password) = (
        createUserRequest.email,
        createUserRequest.password,
      );
    } catch (ex) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.invalidRequestFormat,
          message: 'Bad request: $ex',
        ).toJson(),
      );
    }

    return resilientResponse(() async {
      final result = await _userService.loginUser(
        email: email,
        password: password,
      );

      return switch (result) {
        LoginUserSuccessful() => Response.json(
            body: LoginUserResponse(
              user: (
                email: result.user.email,
                firstName: result.user.firstName,
                userId: result.user.id,
              ),
              accessToken: result.accessToken,
            ).toJson(),
          ),
        LoginUserFailed() => Response.json(
            body: const ErrorResponse(
              ribbitServerErrorCode: RibbitServerErrorCode.loginFailed,
              message: 'Login Failed',
            ).toJson(),
          ),
      };
    });
  }
}
