import 'package:ribbit_client/src/core/failure/failure.dart';

final class UnknownExceptionFailure extends Failure {
  const UnknownExceptionFailure({
    required this.exception,
    required this.trace,
  });

  final Exception exception;
  final StackTrace trace;
}
