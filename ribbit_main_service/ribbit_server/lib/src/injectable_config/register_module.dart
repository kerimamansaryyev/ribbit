import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class RegisterModule {
  @singleton
  DotEnv get dotEnv => DotEnv(includePlatformEnvironment: true)..load();

  @singleton
  Logger get logger => Logger();

  @injectable
  http.Client get client => http.Client();
}
