import 'dart:convert';
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:ribbit_server/src/app/entity/ribbit_notification_scheduler_login_request.dart';
import 'package:ribbit_server/src/app/entity/ribbit_notification_scheduler_schedule_reminder_request.dart';
import 'package:ribbit_server/src/app/integration/ribbit_notification_scheduler_service_delegate.dart';
import 'package:ribbit_server/src/app/utils/http_client_request_delegate.dart';

typedef _ScheduleReminderResponse = ({
  int statusCode,
  Map<String, dynamic> responseDecoded,
});

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
  ) {
    _afterInitialization();
  }

  static const _maxServerResponseWaitDuration = Duration(
    seconds: 10,
  );
  static const _loginEndpointEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_LOGIN_API_ENDPOINT';
  static const _userNameEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_ACCESS_USERNAME';
  static const _passwordEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_ACCESS_PASSWORD';

  static const _reminderScheduleEndpointEnvKey =
      'RIBBIT_NOTIFICATION_SCHEDULER_SCHEDULE_REMINDER_API_ENDPOINT';

  final HttpClientRequestDelegate _client;
  final String _schedulerAccessToken;
  final Uri _reminderScheduleEndpoint;
  final Logger _logger;

  void _afterInitialization() {
    _logger.i(
      'The scheduler service is running! Access Token: $_schedulerAccessToken',
    );
  }

  @FactoryMethod(
    preResolve: true,
  )
  static Future<RibbitNotificationSchedulerServiceDelegateImpl> init(
    HttpClientRequestDelegate requestDelegate,
    DotEnv env,
    Logger logger,
  ) async {
    final loginEndpoint = Uri.tryParse(
      '${env[_loginEndpointEnvKey]}',
    );
    if (loginEndpoint == null) {
      throw Exception('Invalid $_loginEndpointEnvKey');
    }

    final reminderScheduleEndpoint = Uri.tryParse(
      '${env[_reminderScheduleEndpointEnvKey]}',
    );
    if (reminderScheduleEndpoint == null) {
      throw Exception('Invalid $_reminderScheduleEndpointEnvKey');
    }

    final (:username, :password) = (
      username: env[_userNameEnvKey]?.toString(),
      password: env[_passwordEnvKey]?.toString(),
    );

    if (username == null || password == null) {
      throw Exception('Invalid $_userNameEnvKey or $_passwordEnvKey');
    }

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
      ),
    );
  }

  @override
  Future<void> scheduleReminder(
    RibbitNotificationSchedulerServiceDelegateScheduleReminderDTO reminder,
  ) async {
    try {
      final response = await _client<_ScheduleReminderResponse>(
        responseMaker: (httpClient) => httpClient.post(
          _reminderScheduleEndpoint,
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            HttpHeaders.authorizationHeader: 'Bearer $_schedulerAccessToken',
          },
          body: jsonEncode(
            RibbitNotificationSchedulerScheduleReminderRequest(
              reminderId: reminder.reminderId.toString(),
              reminderDate: reminder.reminderDate.toLocal().toUtc(),
              reminderTitle: reminder.reminderTitle,
              reminderDescription: reminder.reminderDescription,
              userId: reminder.userId,
            ).toJson(),
          ),
        ),
        parser: (response, decoded) => (
          statusCode: response.statusCode,
          responseDecoded: decoded,
        ),
      ).timeout(
        _maxServerResponseWaitDuration,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Invalid response\n'
          'Response: ${response.responseDecoded}\n',
        );
      }
    } catch (ex) {
      _logger.f(
        'Could not send notification\n'
        'Sent data: $reminder\n'
        'Exception received: $ex\n',
      );
      rethrow;
    }
  }
}
