import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ribbit_client/src/core/storage/auth_storage.dart';

@injectable
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._authStorage);

  final AuthStorage _authStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? accessToken;

    try {
      accessToken = await _authStorage.getToken();
    } catch (_) {}

    super.onRequest(
      options.copyWith(
        headers: {
          ...options.headers,
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      ),
      handler,
    );
  }
}
