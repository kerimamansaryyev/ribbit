import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/repository/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';

/// Handling requests upon User
@Singleton()
final class UserController {
  /// Injecting dependencies
  const UserController({
    required this.userService,
  });

  /// Using injected UserService for CRUD
  final UserService userService;

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
          message: 'Bad request: $ex',
        ).toJson(),
      );
    }

    try {
      final result = await userService.createUser(
        email: email,
        firstName: firstName,
        password: password,
      );

      return switch (result) {
        CreateUserAlreadyExists() => Response.json(
            statusCode: HttpStatus.forbidden,
            body: const ErrorResponse(
              message: 'User already exists',
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
    } catch (ex) {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: const ErrorResponse(
          message: 'Unexpected Error',
        ).toJson(),
      );
    }
  }
}
