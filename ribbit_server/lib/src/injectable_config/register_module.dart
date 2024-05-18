import 'package:dotenv/dotenv.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  DotEnv get dotEnv => DotEnv(includePlatformEnvironment: true)..load();
}
