import 'package:ribbit_server/src/prisma/generated/client.dart';

/// Any action performed by Database
typedef DatabaseAction<T> = Future<T> Function();

/// Util methods fot repositories
mixin BaseRepositoryMixin {
  PrismaClient _prismaClient = PrismaClient();

  /// Preventing connection to stay alive after an error
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
}
