import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/result/create_user_result.dart';
import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';
import 'package:ribbit_server/src/prisma/generated/prisma.dart';

/// Implementation of [UserRepository] via [PrismaClient]
@Singleton(as: UserRepository)
final class UserRepositoryImpl
    with BaseRepositoryMixin
    implements UserRepository {
  @override
  Future<CreateUserResult> createUser({
    required String email,
    required String password,
    required String firstName,
  }) =>
      preventConnectionLeak(() async {
        final tx = await prismaClient.$transaction.start();
        try {
          final user = await tx.user.findUnique(
            where: UserWhereUniqueInput(
              email: email,
            ),
          );

          final result = user == null
              ? CreateUserSuccessfullyCreated(
                  user: await tx.user.create(
                    data: PrismaUnion.$1(
                      UserCreateInput(
                        email: email,
                        password: password,
                        firstName: firstName,
                      ),
                    ),
                  ),
                )
              : const CreateUserAlreadyExists();

          await tx.$transaction.commit();

          return result;
        } catch (_) {
          await tx.$transaction.rollback();
          rethrow;
        }
      });
}
