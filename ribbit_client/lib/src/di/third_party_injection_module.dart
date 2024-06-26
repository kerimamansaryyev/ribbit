import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_client/src/env_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ThirdPartyInjectionModule {
  @injectable
  Dio get dioClient => Dio(
        BaseOptions(
          baseUrl: EnvConfig.apiEndpointBase.value,
        ),
      );

  @Singleton()
  @FactoryMethod(preResolve: true)
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
