import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ribbit_client/src/core/rest_client/rest_client.dart';

abstract base class InterceptedRestClient extends BaseRestClient {
  InterceptedRestClient(
    super.internalClient,
    this._interceptors,
  );

  final List<Interceptor> _interceptors;

  @protected
  @mustCallSuper
  void useInterceptors() {
    internalClient
      ..interceptors.clear()
      ..interceptors.addAll(_interceptors);
  }

  @visibleForTesting
  Interceptors get interceptorsTest => internalClient.interceptors;
}
