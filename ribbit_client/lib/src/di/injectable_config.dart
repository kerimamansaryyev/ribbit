import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_client/src/di/injectable_config.config.dart';

final serviceLocator = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies({
  required Environment environment,
}) async =>
    serviceLocator.init(
      environment: environment.name,
    );
