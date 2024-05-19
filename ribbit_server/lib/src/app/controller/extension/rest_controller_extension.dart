import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';

typedef JsonRequestParser<T> = T Function(
  RequestContext requestContext,
  Map<String, dynamic> jsonObj,
);
typedef JsonResponseDispatcher<T> = FutureOr<Response> Function(
  RequestContext requestContext,
  T parsedResult,
);

extension RestControllerExtension on RequestContext {
  Future<Response> handleAsJson<T>({
    required JsonRequestParser<T> parser,
    required JsonResponseDispatcher<T> responseDispatcher,
  }) async {
    try {
      final rawData = await request.json() as Map<String, dynamic>;
      final data = parser(this, rawData);
      return responseDispatcher(
        this,
        data,
      );
    } catch (ex) {
      return ErrorResponseFactory.invalidRequestFormat(
        ex,
      );
    }
  }
}
