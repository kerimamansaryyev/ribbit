import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/controller/extension/rest_controller_extension.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';
import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_user_result.dart';
import 'package:ribbit_server/src/app/service/result/login_user_result.dart';
import 'package:ribbit_server/src/app/service/result/set_user_device_token_result.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';

/// Handling requests upon User
@singleton
final class UserController with BaseControllerMixin {
  /// Injecting dependencies
  const UserController(this._userService);

  /// Using injected UserService for CRUD
  final UserService _userService;

  /// Creates User
  Future<Response> createUser(
    RequestContext requestContext,
  ) async {
    return requestContext.handleAsJson<CreateUserRequest>(
      applyInputValidators: (_, createUserRequest) => [
        InputValidators.userEmail(
          fieldName: 'email',
          input: createUserRequest.email,
        ),
        InputValidators.userPassword(
          fieldName: 'password',
          input: createUserRequest.password,
        ),
        InputValidators.firstNameValidator(
          fieldName: 'firstName',
          input: createUserRequest.firstName,
        ),
      ],
      parser: (context, rawData) => CreateUserRequest.fromJson(
        rawData,
      ),
      responseDispatcher: (context, createUserRequest) async {
        final (
          email,
          firstName,
          password,
        ) = (
          createUserRequest.email,
          createUserRequest.firstName,
          createUserRequest.password,
        );

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
      },
    );
  }

  Future<Response> deleteOwnUserAccount(RequestContext requestContext) async {
    return switch (requestContext.request.method) {
      HttpMethod.delete => switch (await _userService.deleteUserById(
          userId: getCurrentUserByRequest(requestContext).id,
        )) {
          DeleteUserDeleted() => Response.json(
              body: DeleteOwnUserAccountResponse(
                message: 'Account successfully deleted',
              ).toJson(),
            ),
          DeleteUserNotFound() => Response.json(
              statusCode: HttpStatus.notFound,
              body: const ErrorResponse(
                ribbitServerErrorCode: RibbitServerErrorCode.userNotFound,
                message: 'User has not been found',
              ).toJson(),
            ),
        },
      _ => Response.json(
          statusCode: HttpStatus.badRequest,
          body: const ErrorResponse(
            ribbitServerErrorCode: RibbitServerErrorCode.invalidRequestFormat,
            message: 'Bad request',
          ).toJson(),
        )
    };
  }

  Future<Response> loginUser(
    RequestContext requestContext,
  ) async {
    return requestContext.handleAsJson<LoginUserRequest>(
      applyInputValidators: null,
      parser: (context, rawData) => LoginUserRequest.fromJson(rawData),
      responseDispatcher: (context, loginUserRequest) async {
        final (email, password) = (
          loginUserRequest.email,
          loginUserRequest.password,
        );

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
              statusCode: HttpStatus.forbidden,
              body: const ErrorResponse(
                ribbitServerErrorCode: RibbitServerErrorCode.loginFailed,
                message: 'Login Failed',
              ).toJson(),
            ),
        };
      },
    );
  }

  Future<Response> deviceCheckIn(
    RequestContext requestContext,
  ) async =>
      requestContext.handleAsJson<DeviceCheckInRequest>(
        applyInputValidators: null,
        parser: (context, decoded) => DeviceCheckInRequest.fromJson(decoded),
        responseDispatcher: (context, deviceCheckInRequest) async =>
            switch (await _userService.setUserDeviceToken(
          userId: getCurrentUserByRequest(context).id,
          deviceToken: deviceCheckInRequest.deviceUserToken,
        )) {
          SetUserDeviceTokenSucceeded() => Response.json(
              body: const DeviceCheckInResponse(
                message: 'Device Token Has Successfully been saved',
              ).toJson(),
            ),
        },
      );
}
