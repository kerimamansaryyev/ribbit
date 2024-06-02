import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:ribbit_server/src/app/entity/ribbit_notification_scheduler_cancel_reminder_request.dart';
import 'package:ribbit_server/src/app/entity/ribbit_notification_scheduler_delete_user_device_token_request.dart';
import 'package:ribbit_server/src/app/entity/ribbit_notification_scheduler_login_request.dart';
import 'package:ribbit_server/src/app/entity/ribbit_notification_scheduler_schedule_reminder_request.dart';
import 'package:ribbit_server/src/app/entity/ribbit_notification_scheduler_set_user_device_token_request.dart';
import 'package:ribbit_server/src/app/integration/ribbit_notification_scheduler_service_delegate.dart';
import 'package:ribbit_server/src/app/utils/http_client_request_delegate.dart';

typedef _EnvParseDelegate<T> = T Function(String val);

@Singleton(
  as: RibbitNotificationSchedulerServiceDelegate,
)
final class RibbitNotificationSchedulerServiceDelegateImpl
    implements RibbitNotificationSchedulerServiceDelegate {
  RibbitNotificationSchedulerServiceDelegateImpl._(
    this._client,
    this._schedulerAccessToken,
    this._logger,
    this._reminderScheduleEndpoint,
    this._setUserDeviceTokenEndpoint,
    this._deleteUserDeviceTokenEndpoint,
    this._cancelReminderEndpoint,
  ) {
    _afterInitialization();
  }

  static const _loginEndpointEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_LOGIN_API_ENDPOINT';
  static const _userNameEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_ACCESS_USERNAME';
  static const _passwordEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_ACCESS_PASSWORD';

  static const _reminderScheduleEndpointEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_SCHEDULE_REMINDER_API_ENDPOINT';

  static const _setUserDeviceTokenEndpointEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_SET_USER_DEVICE_TOKEN_API_ENDPOINT';

  static const _deleteUserDeviceTokenEndpointEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_DELETE_USER_DEVICE_TOKEN_API_ENDPOINT';

  static const _cancelReminderEndpointEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_CANCEL_REMINDER_API_ENDPOINT';

  final HttpClientRequestDelegate _client;
  final String _schedulerAccessToken;
  final Uri _reminderScheduleEndpoint;
  final Uri _setUserDeviceTokenEndpoint;
  final Uri _deleteUserDeviceTokenEndpoint;
  final Uri _cancelReminderEndpoint;
  final Logger _logger;

  void _afterInitialization() {
    _logger.i(
      'The scheduler service is running! Access Token: $_schedulerAccessToken',
    );
  }

  @FactoryMethod(preResolve: true)
  static Future<RibbitNotificationSchedulerServiceDelegateImpl> init(
    HttpClientRequestDelegate requestDelegate,
    DotEnv env,
    Logger logger,
  ) async {
    T getEnvOrThrow<T>({
      required String key,
      required _EnvParseDelegate<T> parser,
    }) {
      try {
        return parser((env[key]?.toString())!);
      } catch (_) {
        throw Exception('Invalid $key');
      }
    }

    final (
      :loginEndpoint,
      :reminderScheduleEndpoint,
      :setUserDeviceTokenEndpoint,
      :username,
      :password,
      :deleteUserDeviceTokenEndpoint,
      :cancelReminderEndpoint
    ) = (
      loginEndpoint: getEnvOrThrow<Uri>(
        key: _loginEndpointEnvKey,
        parser: Uri.parse,
      ),
      reminderScheduleEndpoint: getEnvOrThrow<Uri>(
        key: _reminderScheduleEndpointEnvKey,
        parser: Uri.parse,
      ),
      setUserDeviceTokenEndpoint: getEnvOrThrow<Uri>(
        key: _setUserDeviceTokenEndpointEnvKey,
        parser: Uri.parse,
      ),
      username: getEnvOrThrow<String>(
        key: _userNameEnvKey,
        parser: (v) => v,
      ),
      password: getEnvOrThrow<String>(
        key: _passwordEnvKey,
        parser: (p) => p,
      ),
      deleteUserDeviceTokenEndpoint: getEnvOrThrow<Uri>(
        key: _deleteUserDeviceTokenEndpointEnvKey,
        parser: Uri.parse,
      ),
      cancelReminderEndpoint: getEnvOrThrow<Uri>(
        key: _cancelReminderEndpointEnvKey,
        parser: Uri.parse,
      ),
    );

    return requestDelegate<RibbitNotificationSchedulerServiceDelegateImpl>(
      responseMaker: (httpClient) => httpClient.post(
        loginEndpoint,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
        body: jsonEncode(
          RibbitNotificationSchedulerLoginRequest(
            userName: username,
            password: password,
          ).toJson(),
        ),
      ),
      parser: (response, data) =>
          RibbitNotificationSchedulerServiceDelegateImpl._(
        requestDelegate,
        data['access_token'] as String,
        logger,
        reminderScheduleEndpoint,
        setUserDeviceTokenEndpoint,
        deleteUserDeviceTokenEndpoint,
        cancelReminderEndpoint,
      ),
    );
  }

  @override
  Future<void> scheduleReminder(
    RibbitNotificationSchedulerServiceDelegateScheduleReminderDTO reminder,
  ) =>
      _client<void>(
        responseMaker: (httpClient) => httpClient.post(
          _reminderScheduleEndpoint,
          headers: _headers,
          body: jsonEncode(
            RibbitNotificationSchedulerScheduleReminderRequest(
              reminderId: reminder.reminderId,
              reminderDate: reminder.reminderDate.toLocal().toUtc(),
              reminderTitle: reminder.reminderTitle,
              reminderDescription: reminder.reminderDescription,
              userId: reminder.userId,
            ).toJson(),
          ),
        ),
        logSentData: reminder.toString(),
        parser: _expectSuccessResponse,
      );

  @override
  Future<void> setUserDeviceToken({
    required String userId,
    required String deviceToken,
  }) =>
      _client<void>(
        responseMaker: (httpClient) => httpClient.post(
          _setUserDeviceTokenEndpoint,
          headers: _headers,
          body: jsonEncode(
            RibbitNotificationSchedulerSetUserDeviceTokenRequest(
              userId: userId,
              deviceToken: deviceToken,
            ).toJson(),
          ),
        ),
        parser: _expectSuccessResponse,
      );

  @override
  Future<void> deleteUserDeviceToken({required String userId}) => _client<void>(
        responseMaker: (httpClient) => httpClient.delete(
          _deleteUserDeviceTokenEndpoint,
          headers: _headers,
          body: jsonEncode(
            RibbitNotificationSchedulerDeleteUserDeviceTokenRequest(
              userId: userId,
            ).toJson(),
          ),
        ),
        parser: _expectSuccessResponse,
      );

  @override
  Future<void> cancelReminder({required String reminderId}) => _client<void>(
        responseMaker: (httpClient) => httpClient.post(
          _cancelReminderEndpoint,
          headers: _headers,
          body: jsonEncode(
            RibbitNotificationSchedulerCancelReminderRequest(
              reminderId: reminderId,
            ).toJson(),
          ),
        ),
        parser: _expectSuccessResponse,
      );

  Map<String, String> get _headers => {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.authorizationHeader: 'Bearer $_schedulerAccessToken',
      };

  static void _expectSuccessResponse(
    http.Response response,
    Map<String, dynamic> decoded,
  ) =>
      response.statusCode != 200
          ? throw Exception(
              'Invalid response\n'
              'Response: $decoded\n',
            )
          : null;
}
