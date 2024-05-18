import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';

/// Used to inject third-party objects
@module
abstract class RegisterModule {
  /// Making sure that the database is available
  @singleton
  @preResolve
  Future<PrismaClient> prismaClient() => Future(() async {
        final prismaClient = PrismaClient();
        try {
          // ignore: avoid_print
          print('Connecting Prisma Client');
          // ignore: avoid_print
          print('Prisma Client was successfully connected');
          return prismaClient;
        } catch (ex) {
          // ignore: avoid_print
          print('');
          log('Failed to connect Prisma Client: $ex');
          rethrow;
        } finally {
          await prismaClient.$disconnect();
        }
      });
}
