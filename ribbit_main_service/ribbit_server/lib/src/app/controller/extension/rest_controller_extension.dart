import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';
import 'package:ribbit_server/src/app/controller/mixin/base_controller_mixin.dart';

typedef JsonRequestParser<T> = T Function(
  RequestContext requestContext,
  Map<String, dynamic> jsonObj,
);
typedef JsonResponseDispatcher<T> = FutureOr<Response> Function(
  RequestContext requestContext,
  T parsedResult,
);

typedef RestInputValidatorSupplier<T> = List<InputValidator<dynamic>> Function(
  RequestContext context,
  T parsedResult,
);

extension RestControllerExtension on RequestContext {
  Future<Response> handleAsJson<T>({
    required RestInputValidatorSupplier<T>? applyInputValidators,
    required JsonRequestParser<T> parser,
    required JsonResponseDispatcher<T> responseDispatcher,
  }) async {
    try {
      final rawData = await request.json() as Map<String, dynamic>;
      final data = parser(this, rawData);

      final invalidField = BaseControllerMixin.validateInputs(
        applyInputValidators?.call(this, data) ?? [],
      );

      if (invalidField != null) {
        return ErrorResponseFactory.invalidInput(
          invalidField.fieldName,
        );
      }

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
