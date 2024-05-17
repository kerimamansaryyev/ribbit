import 'package:get_it/get_it.dart';
import 'package:hellav_server/src/injectable_config/di_init.config.dart';
import 'package:injectable/injectable.dart';

/// Global Service locator
final appServiceLocator = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)

/// To be called before launching the server
Future<void> configureDependencies() => appServiceLocator.init();
