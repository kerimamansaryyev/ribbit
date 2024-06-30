import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_client/src/core/rest_client/intercepted_rest_client.dart';
import 'package:ribbit_client/src/features/auth/data/interceptor/token_interceptor.dart';

@injectable
final class AuthGuardedRestClient extends InterceptedRestClient {
  AuthGuardedRestClient(
    Dio internalClient,
    TokenInterceptor tokenInterceptor,
  ) : super(
          internalClient,
          [
            tokenInterceptor,
          ],
        );

  @postConstruct
  @override
  void useInterceptors() {
    super.useInterceptors();
  }
}
