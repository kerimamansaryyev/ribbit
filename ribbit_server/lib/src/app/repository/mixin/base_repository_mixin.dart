import 'package:ribbit_server/src/app/input_validator/input_validator.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';

typedef DatabaseAction<T> = Future<T> Function();

mixin BaseRepositoryMixin {
  PrismaClient _prismaClient = PrismaClient();

  Future<T> preventConnectionLeak<T>(DatabaseAction<T> action) async {
    try {
      return await action();
    } catch (_) {
      await _prismaClient.$disconnect();
      _replaceClient();
      rethrow;
    }
  }

  PrismaClient get prismaClient => _prismaClient;

  void _replaceClient() => _prismaClient = PrismaClient();

  InputValidator<dynamic>? validateInputs(
    List<InputValidator<dynamic>> validators,
  ) {
    for (final validator in validators) {
      if (!validator.isValid()) {
        return validator;
      }
    }
    return null;
  }
}
