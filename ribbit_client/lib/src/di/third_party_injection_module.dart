import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_client/src/core/rest_client/auth_interceptor.dart';
import 'package:ribbit_client/src/env_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ThirdPartyInjectionModule {
  @injectable
  Dio dioClient(AuthInterceptor authInterceptor) => Dio(
        BaseOptions(
          baseUrl: EnvConfig.apiEndpointBase.value,
        ),
      )..interceptors.addAll([
          authInterceptor,
        ]);

  @Singleton()
  @FactoryMethod(preResolve: true)
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
