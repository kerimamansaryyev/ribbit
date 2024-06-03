import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/app/integration/jwt_authenticator.dart';
import 'package:ribbit_server/src/app/integration/ribbit_notification_scheduler_service_delegate.dart';
import 'package:ribbit_server/src/app/repository/exception/create_user_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/delete_user_by_id_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/validate_user_credentials_exception.dart';
import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/app/service/result/create_user_result.dart';
import 'package:ribbit_server/src/app/service/result/delete_user_result.dart';
import 'package:ribbit_server/src/app/service/result/login_user_result.dart';
import 'package:ribbit_server/src/app/service/result/logout_user_result.dart';
import 'package:ribbit_server/src/app/service/result/set_user_device_token_result.dart';
import 'package:ribbit_server/src/app/service/user_service.dart';

@Singleton(as: UserService)
final class UserServiceImpl implements UserService {
  const UserServiceImpl(
    this._jwtAuthenticator,
    this._userRepository,
    this._schedulerServiceDelegate,
  );

  final UserRepository _userRepository;
  final JWTAuthenticator _jwtAuthenticator;
  final RibbitNotificationSchedulerServiceDelegate _schedulerServiceDelegate;

  @override
  Future<CreateUserResult> createUser({
    required String email,
    required String password,
  }) async {
    try {
      return CreateUserSuccessfullyCreated(
        user: await _userRepository.createUser(
          email: email,
          password: password,
        ),
      );
    } on CreateUserException catch (ex) {
      switch (ex) {
        case CreateUserAlreadyExistsException():
          return const CreateUserAlreadyExists();
      }
    }
  }

  @override
  Future<LoginUserResult> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _userRepository.validateUserCredentials(
        email: email,
        password: password,
      );

      final accessToken = _jwtAuthenticator.generateToken(
        userId: user.id,
        email: email,
      );

      return LoginUserSuccessful(
        accessToken: accessToken,
        user: user,
      );
    } on ValidateUserCredentialsException catch (ex) {
      switch (ex) {
        case ValidateUserCredentialsInvalidException():
          return const LoginUserFailed();
      }
    }
  }

  @override
  Future<UserRepositoryGetUserByIdDTO?> verifyFromToken({
    required String token,
  }) async {
    final userId = _jwtAuthenticator.getPayloadFromToken(token: token)?.userId;
    if (userId == null) {
      return null;
    }
    return _userRepository.getUserByUserId(userId: userId);
  }

  @override
  Future<DeleteUserResult> deleteUserById({required String userId}) async {
    try {
      await _schedulerServiceDelegate.deleteUserDeviceToken(
        userId: userId,
      );
      await _userRepository.deleteUserById(
        userId: userId,
      );
      return const DeleteUserDeleted();
    } on DeleteUserByIdException catch (ex) {
      switch (ex) {
        case DeleteUserByIdNotFoundException():
          return const DeleteUserNotFound();
      }
    }
  }

  @override
  Future<SetUserDeviceTokenResult> setUserDeviceToken({
    required String userId,
    required String deviceToken,
  }) async {
    await _schedulerServiceDelegate.setUserDeviceToken(
      userId: userId,
      deviceToken: deviceToken,
    );
    return const SetUserDeviceTokenSucceeded();
  }

  @override
  Future<LogoutUserResult> logoutUser({required String userId}) async {
    await _schedulerServiceDelegate.deleteUserDeviceToken(
      userId: userId,
    );
    return const LogoutUserSucceeded();
  }
}
