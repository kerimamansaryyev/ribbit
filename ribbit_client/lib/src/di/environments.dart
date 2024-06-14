import 'package:injectable/injectable.dart';

const appDevEnvironment = Environment('development');
const appProductionEnvironment = Environment('production');

Environment selectEnvironmentFromString(String envName) {
  return [appDevEnvironment, appProductionEnvironment].firstWhere(
    (env) => env.name == envName,
    orElse: () => appDevEnvironment,
  );
}
