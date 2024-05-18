import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
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

    try {
      final createUserRequest = CreateUserRequest.fromJson(
        await requestContext.request.json() as Map<String, dynamic>,
      );
      (email, firstName) = (
        createUserRequest.email,
        createUserRequest.firstName,
      );
    } catch (ex) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: ErrorResponse(
          message: 'Bad request: $ex',
        ).toJson(),
      );
    }

    final createdUserDTO = await userService.createUser(
      email: email,
      firstName: firstName,
    );

    return Response.json(
      body: CreateUserResponse(
        user: (
          firstName: createdUserDTO.firstName,
          email: createdUserDTO.email,
          userId: createdUserDTO.userId,
        ),
        accessToken: 'accessToken',
      ).toJson(),
    );
  }
}
