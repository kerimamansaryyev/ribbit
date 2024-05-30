import 'dart:async';

import 'package:ribbit_server/src/app/repository/exception/expected_repository_exception.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';

typedef DatabaseAction<T> = Future<T> Function();
typedef BaseRepositoryBeforeCommitDelegate<T> = FutureOr<void> Function(
  T entity,
);

mixin BaseRepositoryMixin {
  PrismaClient _prismaClient = PrismaClient();

  Future<T> preventConnectionLeak<T>(DatabaseAction<T> action) async {
    try {
      return await action();
    } catch (ex) {
      if (ex is! ExpectedRepositoryException) {
        await _prismaClient.$disconnect();
        _replaceClient();
      }
      rethrow;
    }
  }

  PrismaClient get prismaClient => _prismaClient;

  void _replaceClient() => _prismaClient = PrismaClient();
}
