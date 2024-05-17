import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/injectable_config/di_init.config.dart';

/// Global Service locator
final appServiceLocator = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)

/// To be called before launching the server
Future<void> configureDependencies() => appServiceLocator.init();
