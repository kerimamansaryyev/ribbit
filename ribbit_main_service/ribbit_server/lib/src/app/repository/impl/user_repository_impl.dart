import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:orm/orm.dart';
import 'package:ribbit_server/src/app/repository/exception/create_user_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/delete_user_by_id_exception.dart';
import 'package:ribbit_server/src/app/repository/exception/validate_user_credentials_exception.dart';
import 'package:ribbit_server/src/app/repository/mixin/base_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/mixin/encrypted_repository_mixin.dart';
import 'package:ribbit_server/src/app/repository/user_repository.dart';
import 'package:ribbit_server/src/prisma/generated/client.dart';
import 'package:ribbit_server/src/prisma/generated/prisma.dart';

/// Implementation of [UserRepository] via [PrismaClient]
@Singleton(as: UserRepository)
final class UserRepositoryImpl
    with BaseRepositoryMixin, EncryptedRepositoryMixin
    implements UserRepository {
  @override
  Future<UserRepositoryCreateUserDTO> createUser({
    required String email,
    required String password,
  }) =>
      preventConnectionLeak(() async {
        final tx = await prismaClient.$transaction.start();
        try {
          final user = await tx.user.findUnique(
            where: UserWhereUniqueInput(
              email: email,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          if (user != null) {
            throw const CreateUserAlreadyExistsException();
          }

          final createdUser = await tx.user.create(
            data: PrismaUnion.$1(
              UserCreateInput(
                email: email,
                password: hasString(password),
              ),
            ),
          );

          final result = (
            id: createdUser.id!,
            email: createdUser.email!,
          );

          await tx.$transaction.commit();

          return result;
        } catch (_) {
          await tx.$transaction.rollback();
          rethrow;
        }
      });

  @override
  Future<UserRepositoryValidateUserCredentialsDTO> validateUserCredentials({
    required String email,
    required String password,
  }) =>
      preventConnectionLeak(
        () async {
          final user = await prismaClient.user.findUnique(
            where: UserWhereUniqueInput(
              email: email,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          final userPassword = user?.password;

          if (user == null ||
              userPassword == null ||
              !validateString(given: password, hashed: userPassword)) {
            return throw const ValidateUserCredentialsInvalidException();
          }

          return (
            id: user.id!,
            email: user.email!,
          );
        },
      );

  @override
  Future<UserRepositoryGetUserByIdDTO?> getUserByUserId({
    required String userId,
  }) =>
      preventConnectionLeak(
        () async {
          final user = await prismaClient.user.findUnique(
            where: UserWhereUniqueInput(
              id: userId,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          if (user == null) {
            return null;
          }

          return UserRepositoryGetUserByIdDTO(
            id: user.id!,
            email: user.email!,
          );
        },
      );

  @override
  Future<void> deleteUserById({
    required String userId,
  }) =>
      preventConnectionLeak(() async {
        final tx = await prismaClient.$transaction.start();
        try {
          final user = await tx.user.findUnique(
            where: UserWhereUniqueInput(
              id: userId,
            ),
            include: const UserInclude(
              reminders: PrismaUnion.$1(false),
            ),
          );

          if (user == null) {
            throw const DeleteUserByIdNotFoundException();
          }

          await tx.user.delete(
            where: UserWhereUniqueInput(
              id: userId,
            ),
          );
          await tx.$transaction.commit();
        } catch (_) {
          await tx.$transaction.rollback();
          rethrow;
        }
      });
}
