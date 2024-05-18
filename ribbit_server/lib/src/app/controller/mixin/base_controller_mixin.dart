import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';

typedef ResponsePerformer = Future<Response> Function();

mixin BaseControllerMixin {
  Future<Response> resilientResponse(
      ResponsePerformer responsePerformer) async {
    try {
      return await responsePerformer();
    } catch (ex) {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: const ErrorResponse(
          ribbitServerErrorCode: RibbitServerErrorCode.unexpectedError,
          message: 'Unexpected Error',
        ).toJson(),
      );
    }
  }
}
