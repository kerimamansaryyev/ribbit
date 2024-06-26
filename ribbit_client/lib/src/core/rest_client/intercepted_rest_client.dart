import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_client/src/core/rest_client/rest_client.dart';
import 'package:ribbit_client/src/di/injectable_config.dart';
import 'package:ribbit_client/src/features/auth/data/interceptor/token_interceptor.dart';

typedef InterceptedRestClientFactoryParam = ({
  List<Interceptor> interceptors,
});

@Injectable(order: -1)
final class InterceptedRestClient extends BaseRestClient {
  InterceptedRestClient._(
    super.internalClient,
  );

  @factoryMethod
  factory InterceptedRestClient.internal(
    Dio internalClient,
    @factoryParam InterceptedRestClientFactoryParam param,
  ) =>
      InterceptedRestClient._(
        internalClient
          ..interceptors.addAll(
            param.interceptors,
          ),
      );

  factory InterceptedRestClient.fromEnv(
    InterceptedRestClientFactoryParam param,
  ) =>
      serviceLocator<InterceptedRestClient>(
        param1: param,
      );

  factory InterceptedRestClient.fromEnvWithTokenInterceptorOnly(
    TokenInterceptor tInterceptor,
  ) =>
      InterceptedRestClient.fromEnv(
        (
          interceptors: [
            tInterceptor,
          ],
        ),
      );
}
