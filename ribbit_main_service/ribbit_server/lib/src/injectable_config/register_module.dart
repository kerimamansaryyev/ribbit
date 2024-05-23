import 'package:dotenv/dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class RegisterModule {
  @singleton
  DotEnv get dotEnv => DotEnv(includePlatformEnvironment: true)..load();

  @singleton
  Logger get logger => Logger();
}
