import 'package:ribbit_client/src/core/failure/failure.dart';
import 'package:ribbit_middle_end/ribbit_middle_end.dart';

final class ServerResponseFailure extends Failure {
  const ServerResponseFailure({
    required this.ribbitServerErrorCode,
  });

  final RibbitServerErrorCode ribbitServerErrorCode;
}
